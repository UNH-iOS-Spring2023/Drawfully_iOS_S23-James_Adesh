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

struct SignUp: View {
    
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String=""
    
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
    }
    
    
    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    // Citation : https://firebase.google.com/docs/auth/ios/start
    func register(){
        
        Auth.auth().createUser(withEmail: username, password: password){result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
        
        
        
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
