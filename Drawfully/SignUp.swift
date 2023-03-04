//
//  SignUp.swift
//  Drawfully
//
//  Created by James on 2/26/23.
//

import SwiftUI

//importing firbase auth and core module
import FirebaseAuth
import FirebaseCore
import Firebase

//import package : https://github.com/sanzaru/SimpleToast
import SimpleToast

struct SignUp: View {
    
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String=""
    
    //Boolean to trigger toast
    @State var error:Bool=false
    
    
    // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
    private let toastOptions=SimpleToastOptions(
        alignment: .top,
        hideAfter: 3,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )
    
    //initialising Firebase firestore
    let db = Firestore.firestore()

    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color.mint.ignoresSafeArea()
                
                
                VStack(alignment: .center, spacing: 0){
                    //Added logo display
                    Image("drawing-draw-svgrepo-com")
                        .resizable()
                        //.imageScale(.large)
                        //.foregroundColor(.accentColor)
                        .frame(width: 75, height: 75, alignment: .top)

                    VStack{
                        Text("Sign Up")
                            .font(
                                .system(size: 40)
                            )
                            .bold()
                            .shadow(color: .gray, radius: 1)
                            .padding()
                        
                        
                        TextField("First Name", text: $firstName)
                            .padding(5)
                        TextField("Last Name", text: $lastName)
                            .padding(5)
                        
                        TextField("Username", text: $username).textInputAutocapitalization(.never).padding(5)
                        
                        //Added password field
                        SecureField("Password",text:$password).padding(5)
                        
                        Button(action: register){
                            Text("Submit")
                                .padding(1)
                        }
                        .padding()
                        
                        //Text("Firebase Authentication").padding().underline()
                        
                        // Citation : https://stackoverflow.com/questions/57112026/how-can-i-hide-the-navigation-back-button-in-swiftui
                        // Citation : https://swiftspeedy.com/go-to-another-view-in-swiftui-using-navigationview/
                        //Added navigation to login page
                            NavigationLink(destination: Login().navigationBarBackButtonHidden(true)) {
                                Text("Already a user?").underline().foregroundColor(.black)
                            }
                            .padding()
                        
                        
                                       }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.blue, lineWidth: 4)
                    ).background(.white)
                    .padding(40)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true)
                }
                .padding(.bottom)
            }
        }
        // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
        .simpleToast(isPresented: $error, options: toastOptions, content: {
            Text("All fields not completed!")
        })
    }
    
    
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Citation : https://firebase.google.com/docs/auth/ios/start
    func register(){
        if (username.isEmpty || password.isEmpty || firstName.isEmpty){
            //Triggering toast display
            error.toggle()
            
        }
        else{
            
            Auth.auth().createUser(withEmail: username, password: password){result, error in
                if error != nil{
                    print(error!.localizedDescription)
                }
                else{
                    let user=Auth.auth().currentUser?.uid
                    let data=["FirstName": firstName,
                              "LastName": lastName,
                              "username": username,
                              "streak":1,
                    ]
                    as [String: Any]
                    let ref: DocumentReference? = nil
                    db.collection("users").addDocument(data:data) { err in
                        if let err = err{
                            print ("Error adding document: \(err)")
                        }
                        else{
                            print("Document added with ID: \(String(describing: ref?.documentID))")
                        }
                        
                    }
                }
                
                
                
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
