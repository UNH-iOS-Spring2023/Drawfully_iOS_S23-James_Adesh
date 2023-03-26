//
//  SetUsername.swift
//  Drawfully
//
//  Created by James on 3/26/23.
//
// References:
// Disabling and enabling button on input: https://stackoverflow.com/questions/58942207/swiftui-enable-save-button-only-when-the-inputs-are-not-empty
// Updating Firebase users: https://firebase.google.com/docs/auth/ios/manage-users#update_a_users_profile

import SwiftUI

import Firebase

struct SetUser: View {
    
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Send updated profile fields to proper Firebase locations
    // Preconditions: at least one State variable is non-empty
    // Postconditions: Firebase is updated with respective values, unless an error occurs
    func SaveVariables(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return }
        
        // update the username in firebase auth and firestore
        if !username.isEmpty{
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges{ error in
                if error == nil {
                    print("Error saving first name: \(error)")
                    doPopUp()
                    return
                }
            }
            
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["username": username]){ error in
                    if error == nil {
                        print("Error saving username: \(error)")
                        doPopUp()
                        return
                    }
                }
        }
        
        // update the first name in firebase firestore
        if !firstName.isEmpty {
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["FirstName": firstName]){ error in
                    if error == nil{
                        print("Error saving first name: \(error)")
                        doPopUp()
                        return
                    }
                }
            }
        
        // update the last name in firebase firestore
        if !lastName.isEmpty {
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["LastName": lastName]){ error in
                    if error == nil{
                        print("Error saving last name: \(error)")
                        doPopUp()
                        return
                    }
                }
            }
        
        //TODO input validation
        // update the email in firebase auth
        if !email.isEmpty {
            Auth.auth().currentUser?.updateEmail(to: email) { error in
                if error == nil {
                    print("Error saving email: \(error)")
                    doPopUp()
                    return
                }
            }
        }
        
        if !password.isEmpty{
            Auth.auth().currentUser?.updatePassword(to: password) { error in
                if error == nil {
                    print("Error saving password: \(error)")
                    doPopUp()
                    return
                }
            }
        }
    }
    
    func doPopUp(){
        print("Implement Popup")
    }
    
    
    var body: some View {
        // nice looking header
        let header = VStack{
                HStack{
                    Spacer()
                    Text("User Profile").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                    let isEmpty = username.isEmpty && firstName.isEmpty && lastName.isEmpty && email.isEmpty && password.isEmpty
                    Button("Save", action: SaveVariables).disabled(isEmpty)
                }.padding()
                
        }
        
        // main menu
        let menu = VStack{
            HStack{
                Spacer()
                Text("New Username:")
                TextField("username", text: $username).disableAutocorrection(true)
                Spacer()
            }
            HStack{
                Spacer()
                Text("New First Name:")
                TextField("first name", text: $firstName).disableAutocorrection(true)
                Spacer()
            }
            HStack{
                Spacer()
                Text("New Last Name:")
                TextField("last name", text: $lastName).disableAutocorrection(true)
                Spacer()
            }
            HStack{
                Spacer()
                Text("New Email:")
                TextField("example@example.com", text: $email).disableAutocorrection(true)
                Spacer()
            }
            HStack{
                Spacer()
                Text("New Password:")
                TextField("password", text: $password).disableAutocorrection(true)
                Spacer()
            }

        }.padding().font(.system(size: 25))
        
        VStack{
            header
            Divider()
            menu
            Spacer()
        }
    }
}


struct SetUser_Previews: PreviewProvider {
    static var previews: some View {
        SetUser()
    }
}
