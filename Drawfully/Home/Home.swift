//
//  Home.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//  Citation : //  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7
//  Citation : https://youtu.be/Jpr7CxjJwGo?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

//View Model for making firebase calls and receiving snapshots
// Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7
//class HomeViewModel: ObservableObject{
//
//    @Published var errorMessage:String=""
//    @Published var streakCount:String="T"
//    @Published var CurrentUser:User=User(uid: "", email: "", profileImageUrl: "", username: "", searchName: [], streak: 0, firstName: "", lastName: "")
//    static let shared = HomeViewModel ()
//
//    init()
//    {
//        //fetchCurrentUser()
//        //super.init()
//    }
//
//    func fetchCurrentUser(){
//
//        // If the user hasn't posted the day before, reset their streak to 0
//        // Preconditions: valid firebase user id
//        // Postconditions: if nothing posted yesterday, firebase document has streak set to 0
//        func CheckStreak(uid: String) {
//            let storedDate = UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Calendar.current.date(byAdding: .day, value: -2, to: Date.now)
//
//            // if the date is less than today && if the date is not yesterday
//            if storedDate! < Calendar.current.startOfDay(for: Date.now) && !Calendar.current.isDateInToday(storedDate!.addingTimeInterval(86400)){
//                FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["streak" : 0])
//                print("reset streak to 0")
//                // TODO Screen notifying that streak is lost
//                // TODO properly test the function, since the UserDefaults object can't be stored in simulator
//            }
//            else{
//                print("streak is safe")
//            }
//        }
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
//            return}
//
//        CheckStreak(uid: uid)
//
//
//        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument{snapshot, error in
//            if let error = error{
//                print("Failed to fetch user data : \(error)")
//            }
//
//            guard let data=snapshot?.data() else {
//                return}
//
//            let appUser = User(uid: uid,  email: data["email"] as? String ?? "", profileImageUrl: data["profileImageUrl"] as? String ?? "", username: data["username"] as? String ?? "", searchName: data["searchName"] as? [String] ?? [""], streak: data["streak"] as? Int ?? 0, firstName: data["firstName"] as? String ?? "", lastName: data["lastName"] as? String ?? "")
//            self.CurrentUser=appUser
//
//        }
//    }
//
//}

struct Home: View {
    
    @EnvironmentObject var session: SessionStore
    
    @StateObject var profileService = ProfileService()
    
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    
    //@ObservedObject private var vm = HomeViewModel()
    
    var body: some View {
        
       // NavigationView{
            //Added scroll view for user's images
            VStack{
                HStack{
                    Image("streak").resizable().frame(width:30, height: 30)
                    
                    //Getting streak count from user's data
                    Text(String(self.session.session!.streak))
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("Home").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                }.padding()
                
                
                ScrollView{
                    
                    //Code above this line has to be modified to be using new services made. We have to get rid of fetchCurrentUser function from this class.
                    
                    
                    //Displaying 3 photos in a row
                    LazyVGrid(columns: threeColumns) {
                        ForEach(self.profileService.posts, id:\.postId){
                            (post) in
                            
                            WebImage(url: URL(string : post.mediaUrl)!)
                                .resizable()
                                .frame(width: ((UIScreen.main.bounds.width/3)-5),
                                       height: UIScreen.main.bounds.height/3)
                                .aspectRatio(contentMode: .fill)
                                .padding(5)
                            
                        }
                    }
                    
                }

                
            }
            .onAppear{
                //To check if user is still logged in
                if (self.session.loggedIn == true)
                {
                    
                    //If user is logged in, load user posts again to make the page dynamic and realtime. Example - if a user posts, we want that picture to be visible in that session itself
                    self.profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
                    
                }
            }
        
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
