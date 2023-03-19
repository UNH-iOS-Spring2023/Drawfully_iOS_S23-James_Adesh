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
    @State var email: String=""
    @State var userIsLoggedIn: Bool=false
    @State var statusMessage: String=""
    
    
    //var ref: DatabaseReference!

    //var ref = Database.database().reference()
    
    
    
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

    
    // Citation : https://developer.apple.com/forums/thread/667742
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Switching views as per log in status
    var body: some View{
        //if user is not logged in, display login page
        if userIsLoggedIn==false{
            content
        }
        //if user is logged in, take into the app
        else
        {
                        BottomBar(AnyView(Home()),
                                  AnyView(Community()),
                                  AnyView(Add()),
                                  AnyView(Search()),
                                  AnyView(Settings())
                        )
                        .environmentObject(AppVariables())
        }
    }
    
    var content: some View {
        
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
                        
                        TextField("Email", text: $email).textInputAutocapitalization(.never).padding(5)
                        
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
                    
                    
                    Text(statusMessage).padding()

                }
                .padding(.bottom)
            }
        }
        // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
        .simpleToast(isPresented: $error, options: toastOptions, content: {
            Text("All fields not completed!")
        })
//        .simpleToast(isPresented: $userIsLoggedIn, options: toastOptions, content: {
//            Text("User Account Created Successfully!")
//        })
    }
    
    
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Citation : https://firebase.google.com/docs/auth/ios/start
    func register(){
        if (username.isEmpty || password.isEmpty || firstName.isEmpty || email.isEmpty){
            //Triggering toast display
            error.toggle()
            
        }
        else{
            
            // Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7

            
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password){result, error in
                if error != nil{
                    print(error!.localizedDescription)
                    statusMessage="Sign up failed!"
                }
                
                
                else{
                    
                    // Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7

                    guard let uid=Auth.auth().currentUser?.uid else {return}
                    let ref: DocumentReference? = nil
                    
                    //ChatGPT
                    db.collection("users").document(uid).setData(["FirstName": firstName,
                                                                  "LastName": lastName,
                                                                  "username": username,
                                                                  "email":email,
                                                                  "streak":"1"]){ err in
                        if let err = err{
                            print ("Error adding document: \(err)")
                        }
                        else{
                            print("Document added with ID: \(String(describing: ref?.documentID))")
                        }

                    }
                    
                    
                    //Take to Home
                    userIsLoggedIn.toggle()
                    
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
