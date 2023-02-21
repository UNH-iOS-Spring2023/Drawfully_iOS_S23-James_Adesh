//
//  ContentView.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/14/23.
//

import SwiftUI


//Global variables initializer
class AppVariables: ObservableObject{
    
    @Published var selectedTab:Int=0
    
}

struct ContentView: View {
    @StateObject var app = AppVariables()

    var body: some View {
        
        //Implementing Bottom Bar View with required parameters (Tabs)
        
        BottomBar(AnyView(Home()),
                  AnyView(Community()),
                  AnyView(Add()),
                  AnyView(Search()),
                  AnyView(Settings())
        )
            .environmentObject(AppVariables())
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
