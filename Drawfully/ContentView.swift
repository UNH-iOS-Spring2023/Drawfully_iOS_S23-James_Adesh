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
    @Published var primaryColor:Color=Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)

    
}

struct ContentView: View {
    @StateObject var app = AppVariables()

    var body: some View {
        
        //Implementing Bottom Bar View with required parameters (Tabs)
        
        ZStack{
            
            BottomBar(AnyView(Home()),
                      AnyView(Community()),
                      AnyView(Add()),
                      AnyView(Search()),
                      AnyView(Settings())
            )
            .environmentObject(AppVariables())
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
