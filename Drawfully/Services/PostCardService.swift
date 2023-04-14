//
//  PostCardService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/6/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/J1fd-b8vnpQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation
import Firebase
import SwiftUI

class PostCardService: ObservableObject {
    
    
    //Used to store post as PostModel
    @Published var post: PostModel!
    @Published var isLiked = false
    
    
    //To check if logged in user has liked a particular post or not
    func hasLikedPost()
    {
            
            isLiked = (post.likes["\(Auth.auth().currentUser!.uid)"]==true) ? true : false
    }
    
    
    
    //If a user likes a particular post, the 'likes' array and 'likeCount' for that post must be updated on firebase
    func like(){
        //Incrementing likeCount by 1
        post.likeCount+=1
        isLiked = true
        
        PostService.PostsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["likeCount" : post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": true])
        
        PostService.AllPosts.document(post.postId).updateData([ "likeCount" : post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": true])
        
        PostService.TimelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData([ "likeCount" : post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": true])
    }
    
    
    //If a user unlikes a particular post, the 'likes' array and 'likeCount' for that post must be updated on firebase
    func unlike(){
        //Decrementing likeCount by 1
        post.likeCount-=1
        isLiked = false
        
        PostService.PostsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["likeCount" : post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": false])
        
        PostService.AllPosts.document(post.postId).updateData([ "likeCount" : post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": false])
        
        PostService.TimelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData([ "likeCount" : post.likeCount, "likes.\(Auth.auth().currentUser!.uid)": false])
    }
    
}


