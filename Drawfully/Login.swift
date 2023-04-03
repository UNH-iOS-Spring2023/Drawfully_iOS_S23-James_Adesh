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
    @State var statusMessage: String=""
    //Boolean to trigger toast
    @State var error:Bool=false
    
    //@Binding var isUserCurrentlyLoggedIn: Bool
    
    
    private let toastOptions=SimpleToastOptions(
        alignment: .top,
        hideAfter: 3,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    
    // Citation : https://developer.apple.com/forums/thread/667742
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    var body: some View{
        //if user is not logged in, display login page
        if Auth.auth().currentUser != nil {
//            print("User not nil")
            BottomBar(AnyView(Home()),
                      AnyView(Community()),
                      AnyView(Add()),
                      AnyView(Search()),
                      AnyView(Settings())
            )
            .environmentObject(AppVariables())
        }
        else{
//            print("user is nil")
            content
        }
        

    }
    
    var content: some View {
        ZStack{
            Color.mint.ignoresSafeArea()
            
            
            VStack{
                //Added logo display
                Image("drawing-draw-svgrepo-com")
                    .resizable()
                //.imageScale(.large)
                //.foregroundColor(.accentColor)
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
                    
                    Button(action: login){
                        Text("Submit")
                            .padding(1)
                    }
                    .padding()
                    //Text("Firebase Authentication").padding().underline()
                    
                    //Added navigation to signup page
                    NavigationLink(destination: SignUp().navigationBarBackButtonHidden(true)) {
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
    
    
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Citation : https://firebase.google.com/docs/auth/ios/start
    func login(){
        if(email.isEmpty || password.isEmpty ){
            //Triggering toast display
            error.toggle()
            
        }
        else{
            
            // Citation : https://www.youtube.com/watch?v=yHngqpFpVZU&list=PL0dzCUj1L5JEN2aWYFCpqfTBeVHcGZjGw&index=7
            
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password){result, error in
                if error != nil{
                    print(error!.localizedDescription)
                    statusMessage="Login failed!"
                }
                else
                {
                    statusMessage="Login Successful!"
                    //userIsLoggedIn.toggle()
                    
                    print("user logged in")
                    
                }
            }
        }
    }
}


struct Login_Previews: PreviewProvider {
    //@State static var isUserCurrentlyLoggedOut = false

    static var previews: some View {
        Login()
    }
}
