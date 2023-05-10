//
//  AuthService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/2/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/bh9bTPH3erQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

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
    
    
    // Function to sign up/ register the user through FirebaseAuth using email and password (all other fields are stored on firestore)
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
            //Setting other fields
            FirebaseManager.shared.firestore.collection("users").document(userId).setData(["FirstName": fname,
                                                                                        "LastName": lname,
                                                                                        "username": username,
                                                                                        "email":email,
                                                                                           "streak":"0"]){ err in
                if let err = err{
                    print ("Error adding document: \(err)")
                }
                else{
                    print("Document added with ID: \(String(describing: ref?.documentID))")
                }
            }
            // Storage reference for profile picture of user
            let storageProfileUserId = StorageService.storageProfileId(userId: userId)
            
            let metadata = StorageMetadata()
            metadata.contentType="image/jpg"
            
            //Function call to store profile picture
            StorageService.saveProfileImage(userId: userId, username: username, email: email, firstName: fname, lastName: lname, imageData: imageData, metaData: metadata, storageProfileImageRef: storageProfileUserId, onSuccess: onSuccess, onError: onError)
        }
    }
    
    
    // Function to sign in the user through FirebaseAuth using email and password
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
                    
                    guard var decodedUser = try? User.init(fromDictionary: dict) else {return}
                
                    
                    // Streak handling at login .
                    // CHecking if the user has posted recently (today or day before) else streak set to 0
                    
                    // Citation : https://mammothinteractive.com/get-current-time-with-swiftui-hacking-swift-5-5-xcode-13-and-ios-15/
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YY/MM/dd"
                    let currentDateTime = Date()
                    // Citation : https://developer.apple.com/documentation/foundation/date/formatstyle/timestyle
                    // Citation : https://www.hackingwithswift.com/example-code/language/how-to-compare-dates
                    let dateToday = formatter.string(from: currentDateTime)
                    // get the last date the user posted
                    let lastUploaded = decodedUser.lastUpdated
                    
                    let lastUploadedDate = formatter.date(from: lastUploaded) ?? Date()
                    
                    //If user has posted the previous day or today
                    if !((Calendar.current.isDateInToday(lastUploadedDate.addingTimeInterval(86400))) && (Calendar.current.isDateInToday(lastUploadedDate)))
                    {
                        decodedUser.streak=0
                        FirebaseManager.shared.firestore.collection("users").document(userId).updateData(["streak" : 0])
                    }
                        
                        
                    print ("User signed in successfully (Decoded User Value: ) \(decodedUser)")
                    onSuccess(decodedUser)
                }
            }
        }
        
    }
}


