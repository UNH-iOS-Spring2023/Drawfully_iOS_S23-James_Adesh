//
//  SearchUsers.swift
//  Drawfully
//
//  Created by James on 4/7/23.
//

import Foundation

class SearchQueries : ObservableObject {
    @Published var users: [User] = []
    @Published var savedPosts: [String] = []
    
    init() {
        firebaseUserQuery()
        firebaseUserSavedQuery()
    }
    
    func firebaseUserQuery(){
        FirebaseManager.shared.firestore.collection("users").getDocuments() { (querySnapshot, error) in
            if let err = error {
                print("Error Querying Users: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let value: String = document.get("username") as? String ?? "Unknown"
                    let data = document.data()
                    let queriedUser = User(uid: document.documentID,  email: data["email"] as? String ?? "", profileImageUrl: data["profileImageUrl"] as? String ?? "", username: data["username"] as? String ?? "", searchName: data["searchName"] as? [String] ?? [""], streak: data["streak"] as? Int ?? 0, firstName: data["firstName"] as? String ?? "", lastName: data["lastName"] as? String ?? "")
                    
                    self.users.append(queriedUser)
                }
            }
        }
    }
    
    func firebaseUserSavedQuery(){
        self.savedPosts = ["Falling Water", "Rainy Day", "Harmony"]
    }
}

//should be user models


//should be DrawingModels

