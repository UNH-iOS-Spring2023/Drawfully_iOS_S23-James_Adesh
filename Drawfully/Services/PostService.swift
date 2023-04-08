//
//  PostService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/5/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseFirestore


//Defining class PostService to handle storing and fetching posts
class PostService{
    
    //Defining root storage for posts (which has subcollections named using user's uid and that collection stores all posts made by that user
    static var Posts = AuthService.storeRoot.collection("posts")
    
    //Defining root storage for all drawings/posts
    static var AllPosts = AuthService.storeRoot.collection("drawings")
    
    //Defining another storage collection called timeline to fetch posts in sequence. To be implemented
    static var Timeline = AuthService.storeRoot.collection("timeline")
    
    
    // Function to return document reference to posts' collection's specific user's collection of posts
    static func PostsUserId(userId: String) -> DocumentReference{
        return Posts.document(userId)
    }
    // Function to return document reference to timeline collection's specific user's collection of posts (Will be later used to implement timeline while fetching all posts)
    static func TimelineUserId(userId: String) -> DocumentReference{
        return Timeline.document(userId)
    }
    
    // Function to upload posts
    static func uploadPost(caption: String, title: String, isPublic: Bool, imageData: Data, onSuccess: @escaping()-> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        guard let userId=Auth.auth().currentUser?.uid else{
            return
        }
        
        let postId = PostService.PostsUserId(userId: userId).collection("userPosts").document().documentID
        
        let storagePostRef = StorageService.storagePostId(postId: postId)
        
        //Defining metadata
        let metadata = StorageMetadata() 
        
        metadata.contentType = "image/jpg"
        
        // This call uses StorageService function - savePostPhoto with all attributes
        StorageService.savePostPhoto(userId: userId, caption: caption, title: title, isPublic: isPublic, postId: postId, imageData: imageData, metadata: metadata, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
        
        
    }
    
    // Function to load up specific user's posts
    static func loadUserPosts(userId: String, onSuccess: @escaping(_ posts: [PostModel]) -> Void )
    {
        PostService.PostsUserId(userId: userId).collection("posts").getDocuments { (snapshot,error) in
            guard let snap = snapshot else {
                print("Error loading user posts")
                return
            }
            
            //Creating array of type - PostModel to store all posts
            var posts = [PostModel]()
            
            for doc in snap.documents{
                let dict = doc.data()
                //Decoding received snapshot to a readable dictionary
                guard let decoder = try? PostModel.init(fromDictionary: dict)
                        
                else{
                    return
                }
                //Adding each user to array of posts
                posts.append(decoder)
            }
            onSuccess(posts)
        }
    }
    
}

