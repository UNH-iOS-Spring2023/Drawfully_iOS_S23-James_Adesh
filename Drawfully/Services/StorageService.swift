//
//  StorageService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/3/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/bh9bTPH3erQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-


import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage


class StorageService{
    
    static var storage = Storage.storage()
    
    static var storageRoot = storage.reference()
    
    //Storage root reference for profile pictures
    static var storageProfile = storageRoot.child("profileImage")
    
    //Storage root reference for post/drawing pictures
    static var storagePost = storageRoot.child("drawings")
    
    //function to get storage reference for a post
    static func storagePostId(postId:String) -> StorageReference{
        return storagePost.child(postId)
    }
    
    
    //function to get storage reference for a user's profile picture
    static func storageProfileId(userId:String) -> StorageReference{
        return storageProfile.child(userId)
    }
    
    // function to save user's profile photo
    static func saveProfileImage(userId:String, username:String, email:String, firstName: String, lastName: String, imageData:Data, metaData:StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void){
        
        //Pushing data
        storageProfileImageRef.putData(imageData, metadata: metaData) {
            (StorageMetadata, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
                
            }
            
            //Fetching download url for pushed image
            storageProfileImageRef.downloadURL{
                (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                        //Setting user attributes as per input
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges{
                            (error) in
                            if error != nil{
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    //Initialising a user with input and default values
                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, lastUpdated: "", /*searchName: username.splitString(),*/ streak: 0, firstName: firstName, lastName: lastName)
                    
                    guard let dict = try?user.asDictionary() else {return}
                    
                    //Setting data on firebase
                    firestoreUserId.setData(dict){
                        (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                        
                    }
                    
                    onSuccess(user)
                }
            }
        }
        
    }
    
    // function to save a post/drawing photo
    static func savePostPhoto(userId: String, caption: String, title: String, isPublic: Bool,postId: String, imageData: Data, metadata: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String)-> Void){
        
        
        //Pushing data
        storagePostRef.putData(imageData, metadata: metadata) {
            (StorageMetadata, error) in

            if error != nil {
                onError(error!.localizedDescription)
                return

            }

            storagePostRef.putData(imageData, metadata: metadata){
                
                (StorageMetadata, error) in
                
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                    
                }
                
                storagePostRef.downloadURL{
                    url, error in
                    if let metaImageUrl = url?.absoluteString {
                        //Getting Document reference to store post
                        let firestorePostRef = PostService.PostsUserId(userId: userId).collection("posts").document(postId)

                        //Creating post
                        let post = PostModel.init(caption: caption, likes: [:], saves: [:],ownerId: userId, postId: postId, username: Auth.auth().currentUser!.displayName!, profileImageUrl: Auth.auth().currentUser!.photoURL!.absoluteString, mediaUrl: metaImageUrl,title: title, date: Date().timeIntervalSince1970,  likeCount: 0, isPublic: isPublic)


                        //Encoding post to dictionary for firebase
                        guard let dict = try? post.asDictionary() else {return}

                        //Pushing dictionary to Firebase
                        firestorePostRef.setData(dict){
                            error in
                            if error != nil {
                                onError(error!.localizedDescription)
                                return
                            }

                            //Adding to 'timeline' collection to implement timeline later. TODO
                            //PostService.TimelineUserId(userId: userId).collection("timeline").document(postId).setData(dict)

                            //Adding post to allPosts
                            PostService.AllPosts.document(postId).setData(dict)

                            onSuccess()
                        }
                        
                    }
                }
                
                
            }
            
        }
        
    }
}
