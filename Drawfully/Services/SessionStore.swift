//
//  SessionStore.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/3/23.
// Citation : https://www.youtube.com/watch?v=aOM_MmZm9Q4&list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-&index=8

import Foundation
import Combine
import Firebase
import FirebaseAuth


class SessionStore: ObservableObject {
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet{self.didChange.send(self)}}
        
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen()
    {
        handle=Auth.auth().addStateDidChangeListener({
            (auth,user) in
            if let user = user{
                let firestoreUserId = AuthService.getUserId(userId: user.uid)
                firestoreUserId.getDocument{
                    (document, error) in
                    if let dict = document?.data(){
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

