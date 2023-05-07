//
//  Search.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//
// Reference for User Search Field: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data

import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

struct Search: View {
    
    // A place to store async arrays without using await
    @EnvironmentObject var informationArr: SearchQueries
    
    @State private var search: String = ""
    @State private var scope: String = "Suggestions" // Default page for Inspiration Tab
    @State private var suggestionDisplay = ""
    
//    private var scopeFields: [String] = ["Saved", "Suggestions"]
    
    // Images
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfileService()
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        // Nice looking header
        let header = HStack{
            Spacer()
            
            Text("Inspiration ")
                .font(.title)
                .fontWeight(.bold)
                .padding(.trailing, 0.0)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
                    
            Spacer()
        }
            .padding()
            .background(AppThemeColor)
            
        
    
      
    
        
        // Give random ideas from the database to the user
        // TODO create database implementation
        let suggestions = VStack{
            Text(suggestionDisplay).padding().font(.system(size: 30)).multilineTextAlignment(.center)
            
            
            Button(action: getTime){
                Text("Get a time limit!")
            }.padding().buttonStyle(.bordered).foregroundColor(.white)
                .font(.headline)
                .padding(20)
                .background(AppThemeColor)
                .clipShape(Capsule())
            
            Button(action: getTheme){
                Text("Get a theme!")
            }.padding().buttonStyle(.bordered).foregroundColor(.white)
                .font(.headline)
                .padding(20)
                .background(AppThemeColor)
                .clipShape(Capsule())
            
            Button(action: getObject){
                Text("Get a object!")
            }.padding().buttonStyle(.bordered).foregroundColor(.white)
                .font(.headline)
                .padding(20)
                .background(AppThemeColor)
                .clipShape(Capsule())
        }
            
        
        
    
        
        // Make the body of the UI
        let body = VStack {
//            // Pick which item you want to use
//                Picker("Scope", selection: $scope) {
//                    ForEach(scopeFields, id:\.self){
//                        Text($0)
//                    }
//                }.pickerStyle(.segmented).padding()
//
//            if (scope == "Saved"){ savedDrawings }
//            else if (scope == "Suggestions"){ suggestions }
//            else { suggestions }
            suggestions
        }
        
        
        // Display content
        NavigationStack {
            VStack{
                header
                
                body
                Spacer()
                }
            }
        .accentColor(Color.white)
        }
    
    // return a random predefined time
    // TODO connect this to the database
    func getTime() {
        let times = ["1 Minute", "5 Minutes", "10 Miuntes", "30 Minutes", "1 Hour", "1 Day"]
        suggestionDisplay = "Time:\n" + times.randomElement()!
    }
    
    // return a random predefined theme
    // TODO connect this to database
    func getTheme() {
        let themes = ["Cartoon", "Realist", "Impressionist"]
        suggestionDisplay = "Theme:\n" + themes.randomElement()!
    }
    
    // return a random predefined object
    // TODO connect this to the database
    func getObject() {
        let objects = ["Human", "Fruit", "Building", "What's in front of you", "Landscape", "Nature", "Animal"]
        suggestionDisplay = "Object:\n" + objects.randomElement()!
    }
    
    }


struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search().environmentObject(SearchQueries())
    }
}
