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
    
    // read in the user values, used in textfield background
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    // set the database values, used for textfield inputs
    @State private var setUsername: String = ""
    @State private var setFirstName: String = ""
    @State private var setLastName: String = ""
    @State private var setEmail: String = ""
    @State private var setPassword: String = ""
    
    // user information
    @EnvironmentObject var session: SessionStore

    // alerts for invalid inputs
    @State private var showAlert = false
    @State private var myAlert: Alert?
    
    // Send updated profile fields to proper Firebase locations
    // Preconditions: at least one State variable is non-empty
    // Postconditions: Firebase is updated with respective values, unless an error occurs
    func SaveVariables(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return }
        
        // update the username in firebase auth and firestore, else throw an alert
        if !setUsername.isEmpty{
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = setUsername
            changeRequest?.commitChanges{ error in
                if error == nil {
                    session.session?.username = setUsername
                    print("Saved Username")
                } else {
                    myAlert = Alert(
                        title: Text("Error With Username"),
                                    message: Text("Username could not change! Try again!"),
                        dismissButton: .cancel(Text("Close"))
                    )
                    showAlert.toggle()
                    return
                }
            }
            
            // update username in the user document in firebase
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["username": setUsername]){ error in
                    if error != nil {
                        print("Error saving username: \(error)")
                        myAlert = Alert(
                            title: Text("Error With Username"),
                            message: Text("Username could not change! Try again!"),
                            dismissButton: .cancel(Text("Close"))
                        )
                        showAlert.toggle()
                        return
                    }
                }
        }
        
        // update the first name in firebase document
        if !setFirstName.isEmpty {
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["firstName": setFirstName]){ error in
                    if error == nil{
                        session.session?.firstName = setFirstName
                        print("Saved First Name")
                    } else {
                        myAlert = Alert(
                            title: Text("Error With First Name"),
                            message: Text("First name could not change! Try again!"),
                            dismissButton: .cancel(Text("Close"))
                        )
                        showAlert.toggle()
                        return
                    }
                }
            }
        
        // update the last name in firebase firestore
        if !setLastName.isEmpty {
            FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["lastName": setLastName]){ error in
                if error == nil {
                    session.session?.lastName = setLastName
                    print("Saved last name")
                }
                else if error != nil{
                    print("Error saving last name: \(error)")
                    myAlert = Alert(
                        title: Text("Error With First Name"),
                        message: Text("First name could not change! Try again!"),
                        dismissButton: .cancel(Text("Close"))
                    )
                    showAlert.toggle()
                    return
                }
            }
        }
            
        // update the email in firebase auth
        // TODO input validation
        if !setEmail.isEmpty {
            if !setEmail.contains("@"){
                myAlert = Alert(title: Text("Error With New Email"), message: Text("Email could not change! Invalid email address! Try again!"), dismissButton: .cancel(Text("Close")))
                showAlert.toggle()
                return
            }
            
            Auth.auth().currentUser?.updateEmail(to: setEmail) { error in
                if error == nil{
                    session.session?.email = setEmail
                    print("Saved New Email")
                } else {
                    myAlert = Alert(
                        title: Text("Error With New Email"),
                        message: Text("Error changing Email! Try again!"),
                        dismissButton: .cancel(Text("Close"))
                    )
                    showAlert.toggle()
                    return
                }
            }
        }
        
        // update the password
        // TODO input validation
        if !setPassword.isEmpty{
            if setPassword.count < 8 { //passwords must be 8 characters or more
                myAlert = Alert(
                    title: Text("Error With New Password"),
                    message: Text("Password is too short! Must be 8 characters or more! Try again!"),
                    dismissButton: .cancel(Text("Close"),
                                           action: {})
                )
                showAlert.toggle()
                return
            }
            
            Auth.auth().currentUser?.updatePassword(to: setPassword) { error in //update in firebase
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
        let header = HStack{
            Spacer()
            
            Text("User Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppTextColor)
                .padding(.trailing, 0.0)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // if there is no input, do not allow saves
            let isEmpty = setUsername.isEmpty && setFirstName.isEmpty && setLastName.isEmpty && setEmail.isEmpty && setPassword.isEmpty
            Button("Save", action: SaveVariables)
                .foregroundColor(AppTextColor)
                .disabled(isEmpty)
                .alert(isPresented: $showAlert){
                    myAlert!
                }
        }
            .padding()
            .background(AppThemeColor)
                
        
        
        // main menu, separates all fields to look nice
        let menu = VStack{
            VStack{
                Spacer()
                
                Text("New Username:").multilineTextAlignment(.leading)
                TextField("\(username)", text: $setUsername)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    
                Spacer()
            }
            
            Divider()
            
            VStack{
                Spacer()
                
                Text("New First Name:").multilineTextAlignment(.leading)
                TextField("\(firstName)", text: $setFirstName)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    
                Spacer()
            }
            
            Divider()
            
            VStack{
                Spacer()
                
                Text("New Last Name:").multilineTextAlignment(.leading)
                TextField("\(lastName)", text: $setLastName)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            Divider()
            
            VStack{
                Spacer()
                
                Text("New Email:").multilineTextAlignment(.leading)
                TextField("\(email)", text: $setEmail)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            Divider()
            
            VStack{
                Spacer()
                
                Text("New Password:").multilineTextAlignment(.leading)
                SecureField("password", text: $setPassword)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }

        }
            .padding()
            .font(.system(size: 25))
        
        // display everything
        VStack{
            header
 
            menu
            Spacer()
        }
        .onAppear{
            username=session.session!.username
            firstName=session.session!.firstName
            lastName=session.session!.lastName
            email=session.session!.email
        }
    }
}


struct SetUser_Previews: PreviewProvider {
    static var previews: some View {
        SetUser()
    }
}
