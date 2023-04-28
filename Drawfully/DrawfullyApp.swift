//
//  DrawfullyApp.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/14/23.
// Citation : https://youtu.be/2nTqJz3T3JE?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


@main
struct DrawfullyApp: App {

    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA

    @StateObject var launchScreenState = LaunchScreenStateManager()



    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                            ContentView().environmentObject(SessionStore())
                            
                            if launchScreenState.state != .finished {
                                LaunchScreenView()
                            }
                        }.environmentObject(launchScreenState)
            // Passing SessionStore to track auth states
            //ContentView().environmentObject(SessionStore())
        }
    }
}

// Citation : https://youtu.be/2nTqJz3T3JE?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchoptions:
                     [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("Firebase...")
        FirebaseApp.configure()
        return true
    }
}
