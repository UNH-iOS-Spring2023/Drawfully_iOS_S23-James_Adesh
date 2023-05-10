//
//  Community.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI
import FirebaseAuth

struct Community: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var firebaseSearches: SearchQueries
    
    @StateObject var profileService = ProfileService()

    @StateObject var postCardService = PostCardService()
    @StateObject var communityService = CommunityService()

    
    var body: some View {
        let header = HStack{
            Spacer()
            
            Text("Community")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
            // Navigate to the UserSearch view
            NavigationLink(destination: UserSearch().environmentObject(firebaseSearches)){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTextColor)
                    .frame(alignment: .trailing)
                    .shadow(radius: 3)
            }
        }
            .padding()
            .background(AppThemeColor)
        
        NavigationView{
            VStack {
                header
                
                ScrollView{
                    VStack{
                        ForEach(communityService.posts, id:\.postId){
                            (post) in
                            
                            PostCardImage(post: post)
                            PostCard(post: post)
                            Rectangle()
                                .fill(Color(UIColor.lightGray))
                                .frame(height:2)
                        }
                    }
                }
                // Citation : ChatGPT
                .refreshable {
                    // This closure will be called when the ScrollView is pulled down
                    communityService.loadAllPosts()
                }
                .onAppear{
                    if (self.session.loggedIn == true)
                    {
                        
                        //If user is logged in, load user posts again to make the page dynamic and realtime. Example - if a user posts, we want that picture to be visible in that session itself
                        self.communityService.loadAllPosts()
                        
                    }
                    
                }
            }
        }.accentColor(.white)
        
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
