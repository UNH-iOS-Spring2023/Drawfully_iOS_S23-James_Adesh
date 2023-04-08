//
//  Notifications.swift
//  Drawfully
//
//  Created by James on 3/7/23.
// References:
// Notification Creation: https://www.hackingwithswift.com/books/ios-swiftui/scheduling-local-notifications
// Notification Scheduling: https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SchedulingandHandlingLocalNotifications.html#//apple_ref/doc/uid/TP40008194-CH5-SW6
// Currently unused:
// Singleton for notifications: https://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/

import UserNotifications

// Enable notifications and request permission to send them. Set a default notification for 18:00 or 6 PM
// Preconditions: none
// Postconditions: Notifications are authorized for Drawfully
func requestNotification(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]){ // ask user for notification permissions, only alerts and badges
        (granted, error) in
            print("notification permissions: (\(granted))")
        if granted {
            var dateInfo = DateComponents()
            dateInfo.hour = 18
            dateInfo.minute = 0
            createNotification(date: dateInfo) // handoff notification creation
        }
    }
}

// Create a notificaiton that corresponds to the Date
// Preconditions: requestNotification() has been run and approved
// Postcondition: a notification is created at the given date time
func createNotification(date: DateComponents){ //takes DateComponents since UNCalendarNotification needs it
    let doNotif = UserDefaults.standard.bool(forKey: "notification")
    if doNotif == false {
        UserDefaults.standard.set(true, forKey: "notification")
        let content = UNMutableNotificationContent() // notification creation
        content.title = "Your daily drawing reminder"
        content.body = "Use Drawfully to practice your drawing"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true) // type of notification trigger
        
        let request = UNNotificationRequest(identifier: "Drawing Reminder", content: content, trigger: trigger) // NSObject creation to prevent repetition
        
        UNUserNotificationCenter.current().add(request) // add notification to NotificationCenter with the ID "Drawing Reminder"
        print("added notification")
    }
}

// Turns of the "Drawing Reminder" notification from the UserNotification Center
// Preconditions: createNotification(date) should be run, however exceptions are handled
// Postconditions: "Drawing Reminder" notitication will not trigger
func removeNotification(){
    UserDefaults.standard.set(false, forKey: "notification")
    //remove the notifiation with the identifier "notification"
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Drawing Reminder"])
    print("removed notification")
}
