//
//  UserView.swift
//  Drawfully
//
//  Created by James on 4/17/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

class UserViewModel: ObservableObject{
    
    @Published var errorMessage:String=""
    @Published var streakCount:String=""
    @Published var CurrentUser:User=User(uid: "", email: "", profileImageUrl: "", username: "", searchName: [], streak: 0, firstName: "", lastName: "")
    
    func fetchCurrentUser(){
        
        // If the user hasn't posted the day before, reset their streak to 0
        // Preconditions: valid firebase user id
        // Postconditions: if nothing posted yesterday, firebase document has streak set to 0
   
    }
    
}



struct UserView: View {
    var user: User
    
    @StateObject var profileService = ProfileService()
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        // NavigationView{
        //Added scroll view for user's images
        VStack{
            HStack{
                Image("streak").resizable().frame(width:30, height: 30)
                
                //Getting streak count from user's data
                Text(String(user.streak))
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text(user.username).font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                Spacer()
            }.padding()
            Text(user.uid).font(.caption).fontWeight(.light).padding(.trailing).multilineTextAlignment(.center)
            Divider()
            
            ScrollView{
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
        .onAppear{ self.profileService.loadUserPosts(userId: user.uid) }
    }
}
    
struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(uid: "Test", email: "", profileImageUrl: "", username: "", searchName: [], streak: 0, firstName: "", lastName: ""))
    }
}
