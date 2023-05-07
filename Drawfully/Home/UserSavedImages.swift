//
//  UserSavedImages.swift
//  Drawfully
//
//  Created by James on 5/7/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


// This view needs to be wrapped in a NavigationStack to function properly
struct UserSavedImages: View {
    
    @EnvironmentObject var session: SessionStore
    
    @StateObject var profileService = ProfileService()
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        
        let header = HStack{
            Spacer()
            
            Text("Saved Drawings")
                .font(.title)
                .fontWeight(.bold)
                .padding(.trailing, 0.0)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
                    
            Spacer()
        }
            .padding()
            .background(AppThemeColor)
        
        // Display the drawings the user has saved
        // Currently set to display the user's posted images, but will be adapted later
        // Same implementation as in the Home.swift file
        let savedDrawings = ScrollView{
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
        
        VStack{
            header
            savedDrawings
            }
        .onAppear{
        //To check if user is still logged in
        if (self.session.loggedIn == true){
            //If user is logged in, load user posts again to make the page dynamic and realtime. Example - if a user posts, we want that picture to be visible in that session itself
            self.profileService.loadUserPosts(userId: Auth.auth().currentUser?.uid ?? "")
        }
        }
    }
}

struct UserSavedImages_Previews: PreviewProvider {
    static var previews: some View {
        UserSavedImages()
    }
}
