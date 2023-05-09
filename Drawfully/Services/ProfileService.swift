//
//  ProfileService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/6/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/J1fd-b8vnpQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation



class ProfileService: ObservableObject{
    
    //Array of PostModel objects to store all user posts
    @Published var posts: [PostModel]=[]
    
    @Published var savedPosts: [PostModel]=[]
    
    //Function to fetch all posts made by the logged in user
    func loadUserPosts(userId:String)
    {
        PostService.loadUserPosts(userId: userId){
            posts in
            
            self.posts=posts
        }
    }
    
    //Function to fetch all posts saved by the logged in user
    func loadSavedPosts(userId:String)
    {
        PostService.loadSavedPosts(userId: userId){
            posts in
            
            self.savedPosts=posts
        }
    }
}
