//
//  SearchUsers.swift
//  Drawfully
//
//  Created by James on 4/7/23.
//

import Foundation

class SearchQueries : ObservableObject {
    @Published var users: [String] = []
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
                    print(value)
                    print("\(document.documentID) => \(document.get("username"))")
                    self.users.append(value)
                }
            }
        }
        print(self.users)
        self.users.sort()
    }
    
    func firebaseUserSavedQuery(){
        self.savedPosts = ["Falling Water", "Rainy Day", "Harmony"]
    }
}

//should be user models


//should be DrawingModels

