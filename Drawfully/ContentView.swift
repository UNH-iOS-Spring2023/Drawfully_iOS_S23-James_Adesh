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

// Global App Theme Color to be accessed anywhere needed
let AppThemeColor: Color = Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)
let AppTextColor: Color = Color.white

struct ContentView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    
    @StateObject var app = AppVariables()
    @StateObject var searchFirebase = SearchQueries() // SearchQueries.swift
    @StateObject var session: SessionStore = SessionStore() // SessionStore.swift
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        //Implementing Bottom Bar View with required parameters (Tabs)
        Group {
            if (session.session != nil && session.loggedIn == true ) {
              BottomBar(AnyView(Home().environmentObject(session)),
                        AnyView(Community().environmentObject(session).environmentObject(searchFirebase)),
                        AnyView(Add().environmentObject(session)),
                        AnyView(Search().environmentObject(searchFirebase)),
                        AnyView(Settings().environmentObject(session))
              )
              .environmentObject(AppVariables())
          } else {
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

