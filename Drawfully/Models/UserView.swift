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

struct UserView: View {
    var user: User // information of the inputted user
    
    @StateObject var profileService = ProfileService() // helps load user posts
    let threeColumns = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)] // helps load posts onto screen
    
    var body: some View {
        
        let header = HStack{
            Image("streak").resizable().frame(width:30, height: 30)
            
            //Getting streak count from user's data
            
            Text(String(user.streak))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
            Text(user.username )
                .font(.title)
                .fontWeight(.bold)
                .padding(.trailing, 42.0)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
        }
            .padding()
            .background(AppThemeColor)
        
        VStack{
            header
            
            // display images, same as the implementation in Home.swift
            NavigationStack{
                ScrollView{
                    //Displaying 3 photos in a row
                    LazyVGrid(columns: threeColumns, spacing: 0) {
                        ForEach(profileService.posts, id:\.postId){
                            (post) in
                            NavigationLink(destination: ViewPublicImage(post: post)){
                                WebImage(url: URL(string : post.mediaUrl)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: ((UIScreen.main.bounds.width/3)))
                                    .aspectRatio(contentMode: .fit)
                                    .border(Color.black, width: 3)
                            }
                        }
                    }
                }
            }.accentColor(.white)
        }
        .onAppear{ self.profileService.loadUserPosts(userId: user.uid) }
    }
}
    
struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(uid: "Test", email: "", profileImageUrl: "", username: "", /*searchName: [],*/ streak: 0, firstName: "", lastName: ""))
    }
}
