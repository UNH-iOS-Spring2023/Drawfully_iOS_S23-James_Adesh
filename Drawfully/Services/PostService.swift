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
import SwiftUI


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
        let storageAllPostRef = StorageService.storagePost
        
        
        //Defining metadata
        let metadata = StorageMetadata() 
        
        metadata.contentType = "image/jpg"
        
        // This call uses StorageService function - savePostPhoto with all attributes
        StorageService.savePostPhoto(userId: userId, caption: caption, title: title, isPublic: isPublic, postId: postId, imageData: imageData, metadata: metadata, storagePostRef: storagePostRef, onSuccess: onSuccess, onError: onError)
//        StorageService.savePostPhoto(userId: userId, caption: caption, title: title, isPublic: isPublic, postId: postId, imageData: imageData, metadata: metadata, storagePostRef: storageAllPostRef, onSuccess: onSuccess, onError: onError)
        
        
    }
    static func loadPost(postId: String, onSuccess: @escaping(_ post: PostModel)->Void)
    {
        PostService.AllPosts.document(postId).getDocument{
            (snapshot, err) in
            guard let snap = snapshot else {
                print("Error loading all posts")
                return
            }
            
            //let dict = snap.data()
            var dict = snap.data()
            if ((dict?.keys.contains("saves")) != nil) {
              
            } else {
                dict!["saves"]=[String:Bool]()
              // does not contain key
            }
            
            guard let decoded = try?PostModel.init(fromDictionary: dict!)
            else{return}
            
            onSuccess(decoded)
            
            
        }
    }
    
    
    // Function to load up specific user's posts
    static func loadUserPosts(userId: String, onSuccess: @escaping(_ posts: [PostModel]) -> Void )
    {
        

        
        PostService.PostsUserId(userId: userId).collection("posts").order(by: "date", descending: true).getDocuments { (snapshot,error) in
            guard let snap = snapshot else {
                print("Error loading user posts")
                return
            }
            
            //Creating array of type - PostModel to store all posts
            var posts = [PostModel]()
            
            for doc in snap.documents{
                var dict = doc.data()
                if dict.keys.contains("saves") {
                  
                } else {
                    dict["saves"]=[String:Bool]()
                  // does not contain key
                }
                
                //dict["saves"]?.append()
                //Decoding received snapshot to a readable dictionary
                guard let decoder = try? PostModel.init(fromDictionary: dict)
                        
                else{
                    print("Going where its not supposed to go")
                    return
                }
                //Adding each user to array of posts
                posts.append(decoder)
            }
            onSuccess(posts)
        }
    }

    // Function to load up all users' posts
    static func loadAllPosts(onSuccess: @escaping(_ posts: [PostModel]) -> Void )
    {
        PostService.AllPosts.order(by: "date", descending: true).getDocuments { (snapshot,error) in
            guard let snap = snapshot else {
                print("Error loading all posts")
                return
            }
            
            //Creating array of type - PostModel to store all posts
            var posts = [PostModel]()
            
            for doc in snap.documents{
                //let dict = doc.data()
                
                var dict = doc.data()
                if dict.keys.contains("saves") {
                  
                } else {
                    dict["saves"]=[String:Bool]()
                  // does not contain key
                }
                //Decoding received snapshot to a readable dictionary
                guard let decoder = try? PostModel.init(fromDictionary: dict)
                        
                else{
                    return
                }
                //Adding each user to array of posts if post is public
                if (decoder.isPublic==true){
                    posts.append(decoder)
                }
            }
            onSuccess(posts)
        }
    }
    
    
    // Function to delete post from firestore and cloud storage
    static func deletePost(postId: String,userId: String, onSuccess: @escaping(_ post: PostModel)->Void)
    {

        // Citation : https://stackoverflow.com/questions/48516763/firestore-swift-4-how-to-get-total-count-of-all-the-documents-inside-a-collect
        PostService.AllPosts.document(postId).delete(){
            (err) in
            if let err = err {
                  print("Error removing document from All Posts: \(err)")
                }
            else {
                print("Document successfully removed from All Posts!")
            }
            
        }
        
        // Citation : https://stackoverflow.com/questions/48516763/firestore-swift-4-how-to-get-total-count-of-all-the-documents-inside-a-collect

        PostService.PostsUserId(userId: userId).collection("posts").document(postId).delete(){
            (err) in
            if let err = err {
                  print("Error removing document from User's collection : \(err)")
                }
            else {
                print("Document successfully removed from User's collection!")
            }
            
        }
        
        
        let storageRef = StorageService.storagePostId(postId: postId)
        //Delete from Cloud Storage
        // Citation : https://firebase.google.com/docs/storage/ios/delete-files
        // Delete the file
        storageRef.delete { error in
          if let error = error {
            print("Error in deleting file from cloud storage")
          } else {
              print("File deleted successfully")
          }
        }
        

    }
    
    // Function to update post in firestore. Updateable fields - Title, Caption, Visibility.
    static func updatePost(userId: String, postId: String, title: String, caption: String, isPublic: Bool,onSuccess: @escaping(_ posts: [PostModel]) -> Void){
        
        // Citation : https://designcode.io/swiftui-advanced-handbook-write-to-firestore
        PostService.AllPosts.document(postId).updateData(["title":title, "caption":caption, "isPublic": isPublic])
        
        PostService.PostsUserId(userId: userId).collection("posts").document(postId).updateData(["title":title, "caption":caption, "isPublic": isPublic])

        
    }
}

