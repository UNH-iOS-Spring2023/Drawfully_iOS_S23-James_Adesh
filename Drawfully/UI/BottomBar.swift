//
//  BottomBar.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
// This file is created using and referring to in-class instructions

import SwiftUI

struct BottomBar: View {
    
    //Environment Object created to access global variables
    @EnvironmentObject private var app: AppVariables
    
    
    //using and referring to in-class instructions
    let Home:AnyView
    let Community:AnyView
    let Add:AnyView
    let Search:AnyView
    let Settings:AnyView
    var bottomBarColor:Color=Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)
    var bottomBarSelectedColor=Color(hue: 0.473, saturation: 0.983, brightness: 0.24)
    
    init(
    _ Home:AnyView,
    _ Community:AnyView,
    _ Add:AnyView,
    _ Search:AnyView,
    _ Settings:AnyView
    ){
        self.Home=Home
        self.Community=Community
        self.Add=Add
        self.Search=Search
        self.Settings=Settings
        
        //Added Colors to Bottom Bar
        
        UITabBar.appearance().barTintColor = UIColor(bottomBarColor)
        UITabBar.appearance().backgroundColor = UIColor(bottomBarColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(.white)
    }
    
    var body: some View {
                
    
            //Bottom Tab Bar defined here
            TabView(selection: $app.selectedTab) {
                
                Home.tabItem
                {
                    //Using SF Symbol icons
                    Image(systemName: "house.fill")
                    
                    Text("Home") }.tag(0)
                
                Community.tabItem
                {
                    //Using SF Symbol icons
                    Image(systemName: "person.3")
                    Text("Community")
                    
                }.tag(1)
                
                
                Add.tabItem
                {
                    //Using SF Symbol icons
                    Image(systemName: "plus.app.fill")
                    
                    Text("Add") }.tag(2)
                
                Search.tabItem
                {
                    //Using SF Symbol icons
                    Image(systemName: "waveform.and.magnifyingglass")
                    Text("Inspiration") }.tag(3)
                
                Settings.tabItem
                {
                    //Using SF Symbol icons
                    Image(systemName: "gearshape.circle.fill")
                    Text("Settings")
                    .lineLimit(0) }.tag(4)
                
            }.accentColor(bottomBarSelectedColor)
        }

}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        
        //Defining Bottom Bar with required parameters
        BottomBar(AnyView(Home()),
                  AnyView(Community()),
                  AnyView(Add()),
                  AnyView(Search()),
                  AnyView(Settings())
        )
            .environmentObject(AppVariables())
    }
}
