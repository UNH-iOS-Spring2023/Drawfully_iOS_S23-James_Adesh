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
                Text("Community") }.tag(1)
            
            Add.tabItem
            {
                //Using SF Symbol icons
                Image(systemName: "plus.app.fill")
            
                Text("Add") }.tag(2)
            
            Search.tabItem
            {
                //Using SF Symbol icons
                Image(systemName: "waveform.and.magnifyingglass")
                Text("Search & Suggestions") }.tag(3)
            
            Settings.tabItem
            {
                //Using SF Symbol icons
                Image(systemName: "gearshape.circle.fill")
                Text("Settings")
                    .lineLimit(0) }.tag(4)
            
        }
        
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        
        //Defining Bottom Bar with required parameters
        //using and referring to in-class instructions
        BottomBar(AnyView(Home()),
                  AnyView(Community()),
                  AnyView(Add()),
                  AnyView(Search()),
                  AnyView(Settings())
        )
            .environmentObject(AppVariables())
    }
}
