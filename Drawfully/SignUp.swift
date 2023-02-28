//
//  SignUp.swift
//  Drawfully
//
//  Created by James on 2/26/23.
//

import SwiftUI

struct SignUp: View {
    
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    var body: some View {
        ZStack{
            Color.mint.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0){
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .frame(width: 0, height: 75, alignment: .top)

                VStack{
                    Text("Sign Up")
                        .font(
                            .system(size: 40)
                        )
                        .bold()
                        .shadow(color: .gray, radius: 1)
                        .padding()
                    
                    TextField("Username", text: $username)
                        .padding(5)
                    TextField("First Name", text: $firstName)
                        .padding(5)
                    TextField("Last Name", text: $lastName)
                        .padding(5)
                    
                    Button(action: submission){
                        Text("Submit")
                            .padding(1)
                    }
                    .padding()
                    
                    Text("Firebase Authentication").padding().underline()
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
    
    func submission(){
        
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
