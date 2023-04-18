//
//  Login.swift
//  Drawfully
//
//  Created by James on 2/26/23.
//
// Citation : https://www.youtube.com/watch?v=6b2WAePdiqA

import SwiftUI

//import package : https://github.com/sanzaru/SimpleToast
import SimpleToast


//importing firbase auth and core module
import FirebaseAuth
import FirebaseCore


struct Login: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var userIsLoggedIn: Bool=false
    @State var statusMessage: String=""
    
    //Boolean to trigger toast
    @State var error:Bool=false
    @State var errorMsg:String=""

    //Fetching Environment Object - session - to track and handle auth states
    @EnvironmentObject var session: SessionStore

    private let toastOptions=SimpleToastOptions(
        alignment: .top,
        hideAfter: 3,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    //Clearing fields after successful login
    func clear(){
        self.password=""
        self.email=""
    }
    
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Citation : https://firebase.google.com/docs/auth/ios/start
    func login(){
        if(email.isEmpty || password.isEmpty ){
            //Triggering toast display
            error.toggle()
        }
        else{
            
            // Use the Auth Service Class to handle sign in
            // Citation : https://www.youtube.com/watch?v=aOM_MmZm9Q4&list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-&index=8&t=1290s
            AuthService.signIn(email: email, password: password, onSuccess: {
                (user) in
                self.clear()
                print("After login \(String(describing: session.session))")
                session.loggedIn = true
                
            }){
                (errorMessage) in
                print("Custom Adesh Error \(errorMessage)")
                self.errorMsg=errorMessage
                return
            }
        }
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.mint.ignoresSafeArea()

                VStack{
                    //Added logo display
                    Image("drawing-draw-svgrepo-com")
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .top)
                    
                    VStack{
                        Text("Login")
                            .font(
                                .system(size: 40)
                            )
                            .bold()
                            .shadow(color: .gray, radius: 1)
                            .padding()
                        
                        TextField("Email", text: $email).textInputAutocapitalization(.never)
                            .padding(5)
                        //Added password field
                        SecureField("Password",text:$password).padding(5)
                        
                        Button(action: {
                            // Setting state to logged in
                            session.loggedIn=true
                            login()
                        }){
                            Text("Submit")
                                .padding(1)
                        }
                        .padding()
                        
                        //Added navigation to signup page
                        NavigationLink(destination: SignUp().navigationBarBackButtonHidden(false)) {
                            Text("New here? Register").underline().foregroundColor(.black)
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
            // Citation : https://www.youtube.com/watch?v=pC6qGSSh9bI
            .simpleToast(isPresented: $error, options: toastOptions, content: {
                Text("All fields not completed!")
            })
        }
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
