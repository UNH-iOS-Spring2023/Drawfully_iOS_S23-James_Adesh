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

var AppThemeColor :Color=Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)

struct ContentView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    
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
            if (session.session != nil && session.loggedIn == true ) {

              BottomBar(AnyView(Home().environmentObject(session)),
                        AnyView(Community().environmentObject(session)),
                        AnyView(Add().environmentObject(session)),
                        AnyView(Search().environmentObject(searchFirebase)),
                        AnyView(Settings().environmentObject(session))
              )
              .environmentObject(AppVariables())

             // HomeView()
          } else {
            //Text("Our authentication screen goes here...")
              Login().environmentObject(session)
          }
        }//.onAppear(perform: getUser)
            .task {
                try? await getUser()
                try? await Task.sleep(for: Duration.seconds(1))
                self.launchScreenState.dismiss()
            }
        
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

