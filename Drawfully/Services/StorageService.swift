//
//  StorageService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/3/23.
// Citation : https://youtu.be/bh9bTPH3erQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-


import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage


class StorageService{
    
    static var storage = Storage.storage()
    
    static var storageRoot = storage.reference(forURL: "gs://drawfully-ios.appspot.com")
    
    static var storageProfile = storageRoot.child("profile")
    
    static func storageProfileId(userId:String) -> StorageReference{
        return storageProfile.child(userId)
    }
    
    static func saveProfileImage(userId:String, username:String, email:String, firstName: String, lastName: String, imageData:Data, metaData:StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void){
        
        storageProfileImageRef.putData(imageData, metadata: metaData) {
            (StorageMetadata, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
                
            }
            
            storageProfileImageRef.downloadURL{
                (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
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
                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, searchName: username.splitString(), streak: 0, firstName: firstName, lastName: lastName)
                    
                    guard let dict = try?user.asDictionary() else {return}
                    
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
    
}
