//
//  FirebaseManager.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 3/4/23.
// New file for Firebase Manager

//Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

// Access to common variables of firebase
class FirebaseManager: NSObject {
    
    let auth: Auth;
    let storage: Storage;
    let firestore: Firestore
    
    static let shared = FirebaseManager ()
    
    override init() {
  //      FirebaseApp.configure ()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage ()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
