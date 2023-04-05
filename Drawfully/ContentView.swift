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

    
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        
        
        
        //Implementing Bottom Bar View with required parameters (Tabs)
        
        //Loading app into signup page
            //Login()
            
        Group {
          if (session.session != nil) {

              BottomBar(AnyView(Home()),
                        AnyView(Community()),
                        AnyView(Add()),
                        AnyView(Search()),
                        AnyView(Settings())
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

