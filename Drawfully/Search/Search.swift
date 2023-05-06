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
    @State private var scope: String = "Users" // Default page for Inspiration Tab
    @State private var suggestionDisplay = ""
    
    private var scopeFields: [String] = ["Users", "Saved", "Suggestions"]
    
    
    
    
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
            
        
        // create the list of all users referenced by the search bar, with filters applied
        var usersList: [User] {
            if search.isEmpty{
                return informationArr.users
            } else {
                return informationArr.users.filter{item in
                    item.username.localizedCaseInsensitiveContains(search) } //if any part matches the current text in search, display it
            }
        }
        
       // After searching, show related Users with the option to navigate to their homepage
        let userSearch = NavigationStack{
            List {
                ForEach(usersList, id: \.self.username) { user in
                    NavigationLink{
                        UserView(user: user) // Navigates to selected User's homepage
                    } label: {
                        Text(user.username)
                    }
                }
            }.navigationTitle("Users")
        }.searchable(text: $search).disableAutocorrection(true).textInputAutocapitalization(.never) // make this area searchable
        
            
            // create the array of all the saved drawings, adhering to search filters
        /* Currently Unused in this context
            var savedDrawingsList: [String] {
                if search.isEmpty{
                    return informationArr.savedPosts
                } else {
                    return informationArr.savedPosts.filter{item in
                        item.localizedCaseInsensitiveContains(search) } //if any part matches the current text in search, display it
                }
            } */
    
        // Display the drawings the user has saved
        // Currently set to display the user's posted images, but will be adapted later
        // Same implementation as in the Home.swift file
        let savedDrawings = NavigationStack{
            ScrollView{
                //Displaying 3 photos in a row
                LazyVGrid(columns: threeColumns) {
                    ForEach(profileService.posts, id:\.postId){
                        (post) in
                        NavigationLink(destination: ViewPublicImage(post: post)){
                            WebImage(url: URL(string : post.mediaUrl)!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: ((UIScreen.main.bounds.width/3)-5))
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                        }
                    }
                }
            }
        }.accentColor(.white)
            .navigationTitle("Saved")
            .onAppear{
            //To check if user is still logged in
            if (self.session.loggedIn == true)
            {
                
                //If user is logged in, load user posts again to make the page dynamic and realtime. Example - if a user posts, we want that picture to be visible in that session itself
                self.profileService.loadUserPosts(userId: Auth.auth().currentUser?.uid ?? "")
                
            }
        }
    
        
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
