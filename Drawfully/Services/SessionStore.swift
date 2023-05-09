//
//  SessionStore.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/3/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
// Citation : https://www.youtube.com/watch?v=aOM_MmZm9Q4&list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-&index=8

import Foundation
import Combine
import Firebase
import FirebaseAuth

// stores and updates the user data through program execution
class SessionStore: ObservableObject {
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet{self.didChange.send(self)}}
    
    
    //To track user state
    //Default 'true' to make sure posts load up if user has logged in earlier on the device and not logged out
    //If user has not logged in, the user will anyway be shown Login Page
    @Published var loggedIn=true
        
    

    var handle: AuthStateDidChangeListenerHandle?
    
    func listen()
    {
        handle=Auth.auth().addStateDidChangeListener({
            (auth,user) in
            if let user = user{
                let firestoreUserId = AuthService.getUserId(userId: user.uid)
                firestoreUserId.getDocument{
                    (document, error) in
                    if var dict = document?.data(){
                        //Removing array of references from fetched snapshot
                        dict.updateValue("", forKey: "drawings")
                        guard let decodedUser = try? User.init(fromDictionary: dict) else {return}
                        self.session = decodedUser
                    }
                }
            }
            else{
                self.session=nil
            }
        })
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            loggedIn = false
        }
        catch{
            
        }
    }
        
    func unbind(){
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit{
        unbind()
    }
        
        
}

