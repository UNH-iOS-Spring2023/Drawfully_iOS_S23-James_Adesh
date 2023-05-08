//
//  Settings.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Settings: View {
    
    // store the user's authorization status
    @EnvironmentObject var session: SessionStore
    var body: some View {
        
        //Add title bar to Settings Tab
        let header = HStack{
            Spacer()
            
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding(.trailing, 0.0)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
            
            Spacer()
        }
            .padding()
            .background(AppThemeColor)
        
        // Debugging settings to help with development
        let debugging = VStack {
            Text("Debugging Buttons").padding().font(.system(size: 30))
            Divider()
            
            // When testing the streak, set the date to either now or two days ago
            ScrollView {
                Text("Testing Streak")
                HStack{
                    // Set the streak date to now
                    Button("Set Date"){
                        UserDefaults.standard.set(Date.now, forKey: "lastDate")
                        print("Date set")
                    }.padding()
                    
                    //Set streak date to two days ago
                    Button("Set Old Date"){
                        UserDefaults.standard.set(Calendar.current.date(byAdding: .day, value: -2, to: Date.now), forKey: "lastDate")
                        print("Old Date set")
                    }.padding()
                }
            }.padding().font(.system(size: 30))
        }
        
        
        let setNotificationCard = VStack {
            Text("Edit Notifications")
                .font(.headline)
                .foregroundColor(AppTextColor)
        }
        
        let setUserCard = VStack {
            Text("Edit Profile")
                .font(.headline)
                .foregroundColor(AppTextColor)
        }
        
        let logoutCard = VStack {
            Text("Logout")
                .font(.headline)
                .foregroundColor(AppTextColor)
        }
        
        // Menu to manage navigation
        let menu = ScrollView {
            VStack(alignment: .center){
                // toggle if you want to receive daily notification: see NotificationManager.swift
                
                // Edit Notifications Settings
                NavigationLink(destination: SetNotifications()){
                    Card(width: 150, height: 75, cornerRadius: 20, views:{ AnyView(setNotificationCard) })
                        .padding(1)
                }
                .padding()
                
                // Edit User's Profile Information
                NavigationLink(destination: SetUser()){
                    
                    Card(width: 150, height: 75, cornerRadius: 20, views:{ AnyView(setUserCard) })
                        .padding(1)
                    
                }
                    .padding()
                
                // Logout the User
                Button(action: {
                    session.loggedIn=false

                    session.logout()} ,label:  {
                        Card(width: 150, height: 75, cornerRadius: 20, views:{ AnyView(logoutCard) })
                            .padding(1)
                    }).padding()
            }
        }
            .font(.system(size: 30))
        
        
        // Display the content
        NavigationView{
            VStack{
                header

                menu
                Spacer()
                
                // TODO Remove for production
//                Divider()
//                debugging
            }
        }
        .accentColor(AppTextColor)
    }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

