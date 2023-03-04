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
    let uid,streak,email,firstName,lastName,username: String
}


//View Model for making firebase calls and receiving snapshots
// Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7
class HomeViewModel: ObservableObject{
    
    @Published var errorMessage:String=""
    @Published var streakCount:String="T"
    @Published var CurrentUser:AppUser=AppUser(uid: "", streak: "", email: "", firstName: "", lastName: "", username: "")
    
    
    init()
    {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return}
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument{snapshot, error in
            if let error = error{
                print("Failed to fetch user data : \(error)")
            }
            
            guard let data=snapshot?.data() else {
                return}
            
            let appUser = AppUser(uid: uid, streak: data["streak"] as? String ?? "", email: data["email"] as? String ?? "", firstName: data["FirstName"] as? String ?? "", lastName: data["LastName"] as? String ?? "", username: data["username"] as? String ?? "")
            self.CurrentUser=appUser
            
        }
    }
}


struct Home: View {
    
    @ObservedObject private var vm = HomeViewModel()
    
    var body: some View {

        //Added scroll view for user's images
        VStack{
            HStack{
                Image("streak").resizable().frame(width:30, height: 30)
                
                //Getting streak count from user's data
                Text(vm.CurrentUser.streak)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("Home").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "magnifyingglass")
            }.padding()
            
            ScrollView{
                VStack{
                    HStack{
                        HomeImage()
                        HomeImage()
                        HomeImage()
                    }
                    HStack{
                        HomeImage()
                        HomeImage()
                        HomeImage()
                    }
                    
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
