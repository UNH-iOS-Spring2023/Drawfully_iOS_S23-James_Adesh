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
import FirebaseAuth

struct SetUser: View {
    
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var session: SessionStore

    
    @State private var showAlert = false
    @State private var myAlert: Alert?
    
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
                    print("Saved Username")
                } else {
                    myAlert = Alert(title: Text("Error With Username"), message: Text("Username could not change! Try again!"), dismissButton: .cancel(Text("Close")))
                    showAlert.toggle()
                    return
                }
            }
            
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["username": username]){ error in
                    if error != nil {
                        print("Error saving username: \(error)")
                        myAlert = Alert(title: Text("Error With Username"), message: Text("Username could not change! Try again!"), dismissButton: .cancel(Text("Close")))
                        showAlert.toggle()
                        return
                    }
                }
        }
        
        // update the first name in firebase firestore
        if !firstName.isEmpty {
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["FirstName": firstName]){ error in
                    if error == nil{
                        print("Saved First Name")
                    } else {
                        myAlert = Alert(title: Text("Error With First Name"), message: Text("First name could not change! Try again!"), dismissButton: .cancel(Text("Close")))
                        showAlert.toggle()
                        return
                    }
                }
            }
        
        // update the last name in firebase firestore
        if !lastName.isEmpty {
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["LastName": lastName]){ error in
                    if error != nil{
                        print("Error saving last name: \(error)")
                            myAlert = Alert(title: Text("Error With First Name"), message: Text("First name could not change! Try again!"), dismissButton: .cancel(Text("Close")))
                            showAlert.toggle()
                        return
                        }
                    }
                }
            
        
        //TODO input validation
        // update the email in firebase auth
        if !email.isEmpty {
            if !email.contains("@"){
                myAlert = Alert(title: Text("Error With New Email"), message: Text("Email could not change! Invalid email address! Try again!"), dismissButton: .cancel(Text("Close")))
                showAlert.toggle()
                return
            }
            Auth.auth().currentUser?.updateEmail(to: email) { error in
                if error == nil{
                    print("Saved New Email")
                } else {
                    myAlert = Alert(title: Text("Error With New Email"), message: Text("Error changing Email! Try again!"), dismissButton: .cancel(Text("Close")))
                    showAlert.toggle()
                    return
                }
            }
        }
        
        //update the password
        if !password.isEmpty{
            if password.count < 8 { //passwords must be 8 characters or more
                myAlert = Alert(title: Text("Error With New Password"), message: Text("Password is too short! Must be 8 characters or more! Try again!"), dismissButton: .cancel(Text("Close"), action: {}))
                showAlert.toggle()
                return
            }
            Auth.auth().currentUser?.updatePassword(to: password) { error in //update in firebase
                if error == nil{
                    print("Saved New Password")
                } else {
                    myAlert = Alert(title: Text("Error With New Password"), message: Text("Password could not change! Try again!"), dismissButton: .cancel(Text("Close"), action: {}))
                    showAlert.toggle()
                    return
                }
            }
        }
    }
    
    var body: some View {
        // nice looking header
        let header = VStack{
                HStack{
                    Spacer()
                    Text("User Profile").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                    let isEmpty = username.isEmpty && firstName.isEmpty && lastName.isEmpty && email.isEmpty && password.isEmpty
                    Button("Save", action: SaveVariables).disabled(isEmpty).alert(isPresented: $showAlert){
                        myAlert!
                    }
                }.padding()
                
        }
        
        // main menu
        let menu = VStack{
            VStack{
                Spacer()
                Text("New Username:").multilineTextAlignment(.leading)
                TextField("username", text: $username).disableAutocorrection(true).multilineTextAlignment(.center)
                Spacer()
            }
            Divider()
            VStack{
                Spacer()
                Text("New First Name:").multilineTextAlignment(.leading)
                TextField("first name", text: $firstName).disableAutocorrection(true).multilineTextAlignment(.center)
                Spacer()
            }
            Divider()
            VStack{
                Spacer()
                Text("New Last Name:").multilineTextAlignment(.leading)
                TextField("last name", text: $lastName).disableAutocorrection(true).multilineTextAlignment(.center)
                Spacer()
            }
            Divider()
            VStack{
                Spacer()
                Text("New Email:").multilineTextAlignment(.leading)
                TextField("bob@example.com", text: $email).disableAutocorrection(true).multilineTextAlignment(.center)
                Spacer()
            }
            Divider()
            VStack{
                Spacer()
                Text("New Password:").multilineTextAlignment(.leading)
                SecureField("password", text: $password).disableAutocorrection(true).multilineTextAlignment(.center)
                Spacer()
            }

        }.padding().font(.system(size: 25))
        
        VStack{
            header
            Divider()
            menu
            Spacer()
        }.onAppear{
            username=session.session!.username
            firstName=session.session!.firstName
            lastName=session.session!.lastName
            email=session.session!.email
            //password=
        }
    }
}


struct SetUser_Previews: PreviewProvider {
    static var previews: some View {
        SetUser()
    }
}
