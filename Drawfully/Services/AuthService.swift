//
//  AuthService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/2/23.
// Citation : https://youtu.be/bh9bTPH3erQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AuthService {
    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            guard let userId = authData?.user.uid else {return}
            
            let storageProfileUserId = StorageService.storageProfileId(userId: userId)
            
            let metadata = StorageMetadata()
            metadata.contentType="image/jpg"
            StorageService.saveProfileImage(userId: userId, username: username, email: email, imageData: imageData, metaData: metadata, storageProfileImageRef: storageProfileUserId, onSuccess: onSuccess, onError: onError)
        }
    }
}


