//
//  DrawfullyApp.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/14/23.
//

import SwiftUI

//importing required firebase libraries
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct DrawfullyApp: App {

    // Citation : https://www.youtube.com/watch?v=6b2WAePdiqA
    //Initialising firebase configuration
    init(){
        FirebaseApp.configure()
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
