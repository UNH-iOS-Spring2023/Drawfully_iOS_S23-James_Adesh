//
//  Search.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//
// Reference for User Search Field: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data

import SwiftUI

struct Search: View {
    @State private var search: String = ""
    @State private var scope: String = "Users"
    @State private var suggestionDisplay = ""
    
    private var users: [String] = firebaseUserQuery() // TODO make user references
    private var favorites: [String] = firebaseUserSavedQuery() // TODO make drawing document references
    private var scopeFields: [String] = ["Users", "Saved", "Suggestions"]
    
    var body: some View {
        // Nice looking header
        let header = VStack{
                HStack{
                    Spacer()
                    Text("Inspiration ").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                }.padding()
            }
        
        // create the list referenced by the search bar, with filters applied
        var usersList: [String] {
            if search.isEmpty{
                return users
            } else {
                return users.filter{item in
                    item.localizedCaseInsensitiveContains(search) } //if any part matches the current text in search, display it
            }
        }
       // After searching, show related Users or Drawings
        let userSearch = NavigationStack{
            List {
                ForEach(usersList, id: \.self) { name in
                    NavigationLink{
                        Text(name) //TODO make visible user page
                    } label: {
                        Text(name)
                    }
                }
            }.navigationTitle("Users")
        }.searchable(text: $search).disableAutocorrection(true).textInputAutocapitalization(.never)
        
            
            // create the array of all the saved drawings, adhering to search filters
            var savedDrawingsList: [String] {
                if search.isEmpty{
                    return favorites
                } else {
                    return favorites.filter{item in
                        item.localizedCaseInsensitiveContains(search) } //if any part matches the current text in search, display it
                }
            }
        
        // Display the drawings
        let savedDrawings = NavigationStack{
            List {
                ForEach(savedDrawingsList, id: \.self) { name in
                    NavigationLink{
                        Text(name) //TODO make visible drawing page
                    } label: {
                        Text(name)
                    }
                }
            }.navigationTitle("Saved")
        }.searchable(text: $search).disableAutocorrection(true).textInputAutocapitalization(.never)
    
        
        // Give random ideas from the database to the user
        let suggestions = VStack{
            Text(suggestionDisplay).padding().font(.system(size: 30)).multilineTextAlignment(.center)
            
            
            Button(action: getTime){
                Text("Get a time limit!")
            }.padding().buttonStyle(.bordered)
            
            Button(action: getTheme){
                Text("Get a theme!")
            }.padding().buttonStyle(.bordered)
            
            Button(action: getObject){
                Text("Get a object!")
            }.padding().buttonStyle(.bordered)
        }
            
        
        
    
        
        // Make the body of the UI
        let body = VStack {
            // Pick which item you want to use
                Picker("Scope", selection: $scope) {
                    ForEach(scopeFields, id:\.self){
                        Text($0)
                    }
                }.pickerStyle(.segmented).padding()
            if (scope == "Users"){ userSearch }
            else if (scope == "Saved"){ savedDrawings }
            else if (scope == "Suggestions"){ suggestions }
            else { userSearch }
        }
        
        
        // Display content
        VStack {
            header
            Divider()
            
            body
            Spacer()
        }
        }
    
    // return a random predefined time
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
        Search()
    }
}
