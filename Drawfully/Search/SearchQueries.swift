//
//  SearchUsers.swift
//  Drawfully
//
//  Created by James on 4/7/23.
//

import Foundation

//should be user models
func firebaseUserQuery() -> [String]{
    var query: [String] = ["test"]
        
    FirebaseManager.shared.firestore.collection("users").getDocuments() { (querySnapshot, error) in
        if let err = error {
            print("Error Querying Users: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let value: String = document.get("username") as? String ?? "Unknown"
                print(value)
                print("\(document.documentID) => \(document.get("username"))")
                query.append(value)
            }
        }
    }
    print(query)
    query.sort()
    
    return query

}


//should be DrawingModels
func firebaseUserSavedQuery() -> [String]{
    let query = ["Falling Water", "Rainy Day", "Harmony"]
    
    return query
}
