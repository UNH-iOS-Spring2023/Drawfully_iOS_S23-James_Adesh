//
//  Settings.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Settings: View {
    
    
    
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
            Button("Set Date"){
                UserDefaults.standard.set(Date.now, forKey: "lastDate")
                print("Date set")
            }
            Button("Set Old Date"){
                UserDefaults.standard.set(Calendar.current.date(byAdding: .day, value: -2, to: Date.now), forKey: "lastDate")
                print("Old Date set")
            }
            }.padding().font(.system(size: 30))
        
        
        NavigationView{
            VStack{
                header
                Divider()
                Spacer()
                menu
                Spacer()
            }
        }
    }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

