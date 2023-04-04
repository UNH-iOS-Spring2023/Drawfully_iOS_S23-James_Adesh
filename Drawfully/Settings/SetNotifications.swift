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
        
        // nice looking header
        let header = VStack{
                HStack{
                    Spacer()
                    Text("Notification Settings").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                }.padding()
                
        }
        
        // main menu
        let menu = VStack{
            HStack{
                Toggle(isOn: $notifs){
                    Text("Notifications")
                    Text("Toggle daily reminder").font(.system(size: 20))
                }.onChange(of: notifs){ notifs in
                    if notifs {
                        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                        createNotification(date: components) } // if the toggle changed, either turn on or off the notification
                    else { removeNotification() }
                }
            }.padding()
            HStack{
                // scrollable picker to change the time a notification is sent
                if notifs{
                    DatePicker("Notification Time", selection: $date, displayedComponents: [.hourAndMinute]).onChange(of: date) { date in
                        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                        UserDefaults.standard.set(date, forKey: "setTime")
                        createNotification(date: components) // when the time is changed, reset the notification. doNotification() has the ability to handle time changes
                        
                    }.padding()
                }
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
