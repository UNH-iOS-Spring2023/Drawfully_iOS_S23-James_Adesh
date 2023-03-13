//
//  Settings.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Settings: View {
    @State private var notifs = UserDefaults.standard.bool(forKey: "notification")
    // see if notifications are on or not
    
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
            HStack{
                Toggle(isOn: $notifs){
                    Text("Notifications")
                    Text("Toggle daily reminder").font(.system(size: 20))
                }.onChange(of: notifs){ _notifs in // I don't really understand why it needs to be _notifs
                    if _notifs { doNotification() }
                    else { removeNotification() }
                }
            }.padding()
            Text("Change Username").padding() // TODO
            Text("Change Email").padding() // TODO
        }.padding().font(.system(size: 30))
        
        VStack{
            header
            Divider()
            Spacer()
            menu
            Spacer()
        }
        }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

