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

func requestNotification(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]){ // ask user for notification permissions
        (granted, error) in print("notification granted: (\(granted))")
    }
    doNotification()
}

func doNotification(){
        let content = UNMutableNotificationContent() // notification creation
        content.title = "Your daily drawing reminder"
        content.body = "Use Drawfully to practice your drawing"
        
        var dateInfo = DateComponents() // time notification should ping
        dateInfo.hour = 18
        dateInfo.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true) // type of trigger

        let request = UNNotificationRequest(identifier: "Drawing Reminder", content: content, trigger: trigger) // NSObject creation to prevent repetition
    // if bugged, try UserDefaults()

        UNUserNotificationCenter.current().add(request) // add notification to NotificationCenter
}
