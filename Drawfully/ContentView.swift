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
    
    @StateObject var searchFirebase = SearchQueries()

    @StateObject var session: SessionStore = SessionStore()
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        
        
        
        //Implementing Bottom Bar View with required parameters (Tabs)
        
        //Loading app into signup page
            //Login()
            
        Group {
          if (session.session != nil) {

              BottomBar(AnyView(Home().environmentObject(session)),
                        AnyView(Community(newSession: session)),
                        AnyView(Add().environmentObject(session)),
                        AnyView(Search().environmentObject(searchFirebase)),
                        AnyView(Settings().environmentObject(session))
              )
              .environmentObject(AppVariables())

             // HomeView()
          } else {
            //Text("Our authentication screen goes here...")
              Login()
          }
        }.onAppear(perform: getUser)
        
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

