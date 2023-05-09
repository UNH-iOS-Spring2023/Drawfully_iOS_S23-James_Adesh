//
//  SearchUsers.swift
//  Drawfully
//
//  Created by James on 4/7/23.
//

import Foundation


// Class that handles the async calls to firebase and stores them
// This implementation is meant to allow the given functions to finish while the async firebase call populates the arrays
class SearchQueries : ObservableObject {
    @Published var users: [User] = [] // array for all queries users
    @Published var savedPosts: [String] = [] // array for all saved drawings, implementation must change to PostCard
    
    init() {
        // Query the database
        firebaseUserQuery()
        firebaseUserSavedQuery()
    }
    
    // Queries the firebase database to populate the users: [Users] array
    // Preconditions: Valid SearchQueries object created
    // Postcontiions: users array is filled with valid User structs
    func firebaseUserQuery(){
        FirebaseManager.shared.firestore.collection("users").getDocuments() { (querySnapshot, error) in
            if let err = error {
                print("Error Querying Users: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let value: String = document.get("username") as? String ?? "Unknown"
                    let data = document.data()
                    let queriedUser = User(uid: document.documentID,  email: data["email"] as? String ?? "", profileImageUrl: data["profileImageUrl"] as? String ?? "", username: data["username"] as? String ?? "", lastUpdated: data["lastUpdated"] as? String ?? "" , /*searchName: data["searchName"] as? [String] ?? [""],*/ streak: data["streak"] as? Int ?? 0, firstName: data["firstName"] as? String ?? "", lastName: data["lastName"] as? String ?? "")
                    
                    self.users.append(queriedUser)
                }
            }
        }
    }
    
    // Queries the firebase database to populate the users: [Users] array
    // TODO currently hardcoded, query firebase to get images
    // Preconditions: Valid SearchQueries object created
    // Postcontiions: savedPosts array is filled with valid strings
    func firebaseUserSavedQuery(){
        self.savedPosts = ["Falling Water", "Rainy Day", "Harmony"]
    }
}
