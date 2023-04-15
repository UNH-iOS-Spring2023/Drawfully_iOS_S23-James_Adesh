//
//  Settings.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var session: SessionStore
    var body: some View {
        
        //Add title bar to Settings Tab
        let header = VStack{
            HStack{
                Spacer()
                Text("Settings").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                Spacer()
            }.padding()
            
        }
        
        // Debugging settings to help with development
        let debugging = VStack {
            Text("Debugging Buttons").padding().font(.system(size: 30))
            Divider()
            
            // When testing the streak, set the date to either now or two days ago
            ScrollView {
                Text("Testing Streak")
                HStack{
                    Button("Set Date"){
                        UserDefaults.standard.set(Date.now, forKey: "lastDate")
                        print("Date set")
                    }.padding()
                    
                    Button("Set Old Date"){
                        UserDefaults.standard.set(Calendar.current.date(byAdding: .day, value: -2, to: Date.now), forKey: "lastDate")
                        print("Old Date set")
                    }.padding()
                }
            }.padding().font(.system(size: 30))
        }
        
        // Menu to manage navigation
        let menu = ScrollView {
            VStack(alignment: .center){
                // toggle if you want to receive daily notification: see NotificationManager.swift
                
                // Edit Notifications
                NavigationLink(destination: SetNotifications()){
                    Text("Edit Notifications")
                }.foregroundColor(.black)
                    .font(.headline)
                    .padding(20)
                    .background(Color.green)
                    .clipShape(Capsule())
                
                // Edit User's Profile
                NavigationLink(destination: SetUser()){
                    Text("Edit Profile")
                }.foregroundColor(.black)
                    .font(.headline)
                    .padding(20)
                    .background(Color.green)
                    .clipShape(Capsule())
                
                Button(action: {
                    self.session.loggedIn=false

                    self.session.logout()} ,label:  {
                    Text("Logout")
                }).foregroundColor(.black)
                    .font(.headline)
                    .padding(20)
                    .background(Color.green)
                    .clipShape(Capsule())
            }
        }.font(.system(size: 30))
        
        
        // Display the content
        NavigationView{
            VStack{
                header
                Divider()
                menu
                
                // Remove for production
                Divider()
                debugging
            }
        }
    }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

