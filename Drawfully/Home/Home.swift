//
//  Home.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//
// Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7


import SwiftUI
import Firebase


//Creating data model for fetching and storing user data
struct AppUser{
    let uid,email,firstName,lastName,username: String
    let streak: Int
    
    //let drawings: Array<Any>
    @State var drawings = [DocumentReference]()
}

//Creating data model for fetching and storing user data
struct DrawingPost{
    let uid,caption,likes,title: String
    let isPublic: Bool
}


//View Model for making firebase calls and receiving snapshots
// Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7
class HomeViewModel: ObservableObject{
    
    @Published var errorMessage:String=""
    @Published var streakCount:String="T"
    @Published var CurrentUser:AppUser=AppUser(uid: "", email: "", firstName: "", lastName: "", username: "", streak: 0, drawings: [])
    @Published var drawing:DrawingPost=DrawingPost(uid:"", caption: "", likes: "", title: "", isPublic: false)
    @Published var posts=[DrawingPost]()
    
    @Published var drawingImages=[UIImage]()
    
    init()
    {
        //fetchCurrentUser()
        //getDrawingImage(x:"")
    }
    
    func fetchCurrentUser(){
        
        // If the user hasn't posted the day before, reset their streak to 0
        // Preconditions: valid firebase user id
        // Postconditions: if nothing posted yesterday, firebase document has streak set to 0
        func CheckStreak(uid: String) {
            let storedDate = UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Calendar.current.date(byAdding: .day, value: -2, to: Date.now)
            
            // if the date is less than today && if the date is not yesterday
            if storedDate! < Calendar.current.startOfDay(for: Date.now) && !Calendar.current.isDateInToday(storedDate!.addingTimeInterval(86400)){
                FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["streak" : 0])
                print("reset streak to 0")
                // TODO Screen notifying that streak is lost
                // TODO properly test the function, since the UserDefaults object can't be stored in simulator
            }
            else{
                print("streak is safe")
            }
        }
        
        
        self.posts=[]
        self.drawingImages=[]
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return}
        
        CheckStreak(uid: uid)
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument{snapshot, error in
            if let error = error{
                print("Failed to fetch user data : \(error)")
            }
            
            guard let data=snapshot?.data() else {
                return}
            
            let appUser = AppUser(uid: uid,  email: data["email"] as? String ?? "", firstName: data["FirstName"] as? String ?? "", lastName: data["LastName"] as? String ?? "", username: data["username"] as? String ?? "", streak: data["streak"] as? Int ?? 0,drawings: data["drawings"] as? [DocumentReference] ?? [] )
            self.CurrentUser=appUser
            //print(appUser.drawings.count)
            
            for doc in appUser.drawings{
                //print(doc)
                //print(doc.path)
                doc.getDocument{ document, error in
                    if let error = error {
                        print("Error getting document: \(error)")
                    } else if let document = document {
                        let art = DrawingPost(uid: document.documentID , caption: document["Caption"] as? String ?? "", likes: document["Likes"]as? String ?? "", title: document["Title"] as? String ?? "", isPublic: document["isPublic"] as? Bool ?? false)
                        self.posts.append(art)
                        //print(art)
                        self.getDrawingImage(x: art.uid)
                        //drawingImages.append(getDrawingImage(x: art.uid) ?? Image("sample_drawing"))
                    }
                }
            }
            
            print(self.posts.count)
            
            
            
            
        }
    }
    
    
    // Citation : https://firebase.google.com/docs/storage/ios/download-files
    func getDrawingImage(x:String)
    {
        // Create a reference with an initial file path and name
        let pathReference = FirebaseManager.shared.storage.reference(withPath: "drawings/\(self.CurrentUser.uid)/\(x)")
        pathReference.getData(maxSize: 2 * 1024 * 1024){ data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error getting drawing image : \(error)")
                return()
            }
            else{
                let image = UIImage(data: data!)
                self.drawingImages.append( image!)
                
            }
        }
    }
    
}


struct Home: View {
    
    @ObservedObject private var vm = HomeViewModel()
    @State private var tabBar: UITabBar! = nil
    @State var c:Int = 0
    
    var body: some View {
        NavigationView{
        //Added scroll view for user's images
        VStack{
            HStack{
                Image("streak").resizable().frame(width:30, height: 30)
                
                //Getting streak count from user's data
                Text(String(vm.CurrentUser.streak))
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("Home").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "magnifyingglass")
            }.padding()
            
            
            ScrollView{
                //Images are now navigation links to their full screen display
                
                    // Citation :  ChatGPT
                    ForEach(vm.drawingImages.chunks(of: 3), id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.self) { image in
                                let img:UIImage = image
                                NavigationLink {
                                    //Link to Destination - full screen view
                                    SelectedImage(img: img)
                                        .toolbar(.hidden, for: .tabBar)
                                    
                                } label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 100,height: 100)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(30)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274), lineWidth: 3))
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
            }
            Spacer()
        }.onAppear(perform: vm.fetchCurrentUser)
            .accentColor(.white)
    }

    
}

// Citation :  ChatGPT
extension Array {
    func chunks(of chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
