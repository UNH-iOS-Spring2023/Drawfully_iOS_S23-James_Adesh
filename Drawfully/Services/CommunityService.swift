//
//  CommunityService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/17/23.
//

import Foundation

class CommunityService: ObservableObject{
    
    //Array of PostModel objects to store all user posts
    @Published var posts: [PostModel]=[]
    
    //Function to fetch all posts made by the logged in user
    func loadAllPosts()
    {
        PostService.loadAllPosts(){
            posts in
            
            self.posts=posts
        }
    }
}
