//
//  ContentView.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/14/23.
//

import SwiftUI
import AVFoundation


//Global variables initializer
class AppVariables: ObservableObject{
    
    @Published var selectedTab:Int=0
    @Published var primaryColor:Color=Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)
}

struct ContentView: View {
    @StateObject var app = AppVariables()
    //default state is that user is logged out
    @State private var isUserCurrentlyLoggedIn: Bool = false

    var body: some View {

        NavigationView{
            //if user is logged in
            if self.isUserCurrentlyLoggedIn{
                BottomBar(AnyView(Home()),
                          AnyView(Community()),
                          AnyView(Add()),
                          AnyView(Search()),
                          AnyView(Settings(isUserCurrentlyLoggedIn: $isUserCurrentlyLoggedIn))
                )
                .environmentObject(AppVariables())
            }
            //if user has not logged in yet
            else
            {
                SignUp(isUserCurrentlyLoggedIn: $isUserCurrentlyLoggedIn)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

