//
//  SetNotifications.swift
//  Drawfully
//
//  Created by James on 3/19/23.
//

import SwiftUI

struct SetNotifications: View {
    
    @State private var notifs = UserDefaults.standard.bool(forKey: "notification")
    // see if notifications are on or not

    @State private var date: Date = UserDefaults.standard.object(forKey: "setTime") as? Date ?? Date.now
    
    var body: some View {
        
        let header = VStack{
                HStack{
                    Spacer()
                    Text("Notification Settings").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                }.padding()
                
        }
        
        let menu = VStack{
            HStack{
                Toggle(isOn: $notifs){
                    Text("Notifications")
                    Text("Toggle daily reminder").font(.system(size: 20))
                }.onChange(of: notifs){ _notifs in // I don't really understand why it needs to be _notifs
                    if _notifs {
                        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                        doNotification(date: components) }
                    else { removeNotification() }
                }
            }.padding()
            HStack{
                DatePicker("Notification Time", selection: $date, displayedComponents: [.hourAndMinute]).onChange(of: date) { date in
                    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                    UserDefaults.standard.set(date, forKey: "setTime")
                    doNotification(date: components)
                }.padding()
            }.font(.system(size: 20))
            

        }
        
        VStack{
            header
            Divider()
            menu
            Spacer()
        }
    }
}

struct SetNotifications_Previews: PreviewProvider {
    static var previews: some View {
        SetNotifications()
    }
}
