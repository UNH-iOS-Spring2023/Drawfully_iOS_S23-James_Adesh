//
//  Settings.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var app: AppVariables
    
    @Binding var isUserCurrentlyLoggedIn: Bool
    var body: some View {
        
        //Add title bar to Settings Tab
        let header = VStack{
            HStack{
                Spacer()
                Text("Settings").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                Spacer()
            }.padding()
            
        }
        
        let menu = VStack(alignment: .leading){
            // toggle if you want to receive daily notification: see Notifications.swift
            NavigationLink(destination: SetNotifications()){
                Text("Edit Notifications")
            }.padding()
            Text("Change Username").padding() // TODO
            Text("Change Email").padding() // TODO
        }.padding().font(.system(size: 30))
        
        
        NavigationView{
            VStack{
                header
                Divider()
                Spacer()
                menu
                Spacer()
                
                //Added Button for logout
                HStack{
                    Spacer()
                    NavigationLink(destination: Login(isUserCurrentlyLoggedIn: $isUserCurrentlyLoggedIn))
                    {
                        Button(action: Logout, label: {
                            Text("Logout")
                        }).padding(10)
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(10)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
            }
            
        }
    }
    
    func Logout()
    {
        do {
            // Citation : https://www.youtube.com/watch?v=XLi-ljpjwdQ
            // Citation : https://firebase.google.com/docs/auth/ios/custom-auth
            try FirebaseManager.shared.auth.signOut()
            // Navigate to your app's login screen or home screen
            self.isUserCurrentlyLoggedIn = false
            
            print ("User Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}

struct Settings_Previews: PreviewProvider {
    @State static var isUserCurrentlyLoggedIn = false
    static var previews: some View {
        Settings(isUserCurrentlyLoggedIn: $isUserCurrentlyLoggedIn)
    }
}

