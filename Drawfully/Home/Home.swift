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
import Introspect

struct Home: View {
    
    @EnvironmentObject var session: SessionStore
    
    @StateObject var profileService = ProfileService()
    
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    @State private var tabBar: UITabBar?
    
    var body: some View {
        
        NavigationView{
            //Added scroll view for user's images
            VStack{
                HStack{
                    Image("streak").resizable().frame(width:30, height: 30)
                    
                    //Getting streak count from user's data
                    Text(String(session.session?.streak ?? 0))
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text(session.session?.username ?? "User").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                    Spacer()
                }.padding()
                
                // If user doesnt have any posts, display appropriate message
                if (self.profileService.posts.isEmpty){
                    HStack{
                        Text("No drawings added 🙁")
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    
                }
                
                ScrollView{
                    
                    //Displaying 3 photos in a row
                    LazyVGrid(columns: threeColumns) {
                        ForEach(self.profileService.posts, id:\.postId){
                            (post) in
                            
                            //Now clicking on image, takes you to fullscreen view
                            NavigationLink(destination: SelectedImage(post: post)){
                                WebImage(url: URL(string : post.mediaUrl)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: ((UIScreen.main.bounds.width/3)-5))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(5)
                                
                            }
                        }
                    }
                    
                }

                
            }
            .onAppear{
                //To check if user is still logged in
                if (session.loggedIn == true)
                {
                    
                    //If user is logged in, load user posts again to make the page dynamic and realtime. Example - if a user posts, we want that picture to be visible in that session itself
                    profileService.loadUserPosts(userId: Auth.auth().currentUser!.uid)
                    
                }
            }
            
        }.accentColor(.white)
        // Citation : https://stackoverflow.com/questions/58444689/swiftui-hide-tabbar-in-subview#comment128904398_72905241
        // To disable bottom bar when viewing an image fullscreen and enable once full screen view is closed
        .introspectTabBarController { UITabBarController in
            tabBar = UITabBarController.tabBar
            self.tabBar?.isHidden = false }
            
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
