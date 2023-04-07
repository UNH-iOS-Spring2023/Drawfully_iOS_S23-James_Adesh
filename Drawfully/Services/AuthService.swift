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

class AuthService  {
    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference {
        return storeRoot.collection("users").document(userId)
    }
    
    static func signUp(fname: String,lname: String,username: String, email: String, password: String, imageData: Data, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            guard let userId = authData?.user.uid else {return}
            
            let ref: DocumentReference? = nil
            
            //ChatGPT
            FirebaseManager.shared.firestore.collection("users").document(userId).setData(["FirstName": fname,
                                                                                        "LastName": lname,
                                                                                        "username": username,
                                                                                        "email":email,
                                                                                           "streak":"1"]){ err in
                if let err = err{
                    print ("Error adding document: \(err)")
                }
                else{
                    print("Document added with ID: \(String(describing: ref?.documentID))")
                }
            }
            let storageProfileUserId = StorageService.storageProfileId(userId: userId)
            
            let metadata = StorageMetadata()
            metadata.contentType="image/jpg"
            StorageService.saveProfileImage(userId: userId, username: username, email: email, firstName: fname, lastName: lname, imageData: imageData, metaData: metadata, storageProfileImageRef: storageProfileUserId, onSuccess: onSuccess, onError: onError)
        }
    }
    
    
    static func signIn(email:String, password: String, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping(_ errorMessage: String)-> Void){
        Auth.auth().signIn(withEmail: email, password: password){
            (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                print ("User signed in failed")
                return
            }
            
            
            guard let userId = authData?.user.uid else {return}

            let firestoreUserId =  getUserId(userId: userId)
            
            firestoreUserId.getDocument{
                (document, error) in
                if var dict = document?.data() {
                    dict.updateValue("", forKey: "drawings")
                    print("Before decoding \(dict)")
                    guard let decodedUser = try? User.init(fromDictionary: dict) else {return}
                    print ("User signed in successfully (Decoded User Value: ) \(decodedUser)")
                    onSuccess(decodedUser)
                }
            }
        }
        
    }
}


