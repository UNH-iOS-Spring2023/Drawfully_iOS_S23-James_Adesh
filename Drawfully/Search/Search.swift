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
//    @State private var scope: String = "Suggestions" // Default page for Inspiration Tab
    @State private var timeDisplay = "Time"
    @State private var themeDisplay = "Theme"
    @State private var subjectDisplay = "Subject"
    @State private var styleDisplay = "Style"
    
    //    private var scopeFields: [String] = ["Saved", "Suggestions"]
    
    // Images
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfileService()
    let threeColumns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        // Nice looking header
        let header = HStack{
            Spacer()
            
            Text("Inspiration")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTextColor)
            
            Spacer()
        }
            .padding()
            .background(AppThemeColor)
        
        
        
        let timeCard = VStack {
            Image(systemName: "timer")
                .resizable()
                .frame(alignment: .center)
                .padding()
                .foregroundColor(AppTextColor)
            
            Spacer()
            
            Text("\(timeDisplay)")
                .font(.title)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
        }
        
        let themeCard = VStack {
            Image(systemName: "paintpalette.fill")
                .resizable()
                .frame(alignment: .center)
                .padding()
                .foregroundColor(AppTextColor)
            
            Spacer()
            
            Text("\(themeDisplay)")
                .font(.title)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
        }
        
        let subjectCard = VStack {
            Image(systemName: "photo.fill")
                .resizable()
                .frame(alignment: .center)
                .padding()
                .foregroundColor(AppTextColor)
            
            Spacer()
            
            Text("\(subjectDisplay)")
                .font(.title)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
        }
        
        let styleCard = VStack {
            Image(systemName: "paintbrush.fill")
                .resizable()
                .frame(alignment: .center)
                .padding()
                .foregroundColor(AppTextColor)
            
            Spacer()
            
            Text("\(styleDisplay)")
                .font(.title)
                .foregroundColor(AppTextColor)
            
            Spacer()
            
        }
            
        
        
        
        
        
        // Give random ideas from the database to the user
        // TODO create database implementation
        let suggestions = VStack{
//            Text(suggestionDisplay)
//                .padding()
//                .font(.system(size: 30))
//                .multilineTextAlignment(.center)
//                .underline(true)
            
            VStack{
                HStack{
                    Button(action: getTime){
                        Card(width: 150, height: 200, cornerRadius: 16, views: { AnyView(timeCard)
                        })
                        .padding(10)
                            .frame(alignment: .leading)
                    }
                    Button(action: getSubject) {
                            Card(width: 150, height: 200, cornerRadius: 16, views: {
                                AnyView(subjectCard)
                            })
                            .padding(10)
                            .frame(alignment: .trailing)
                    }
                }
                
                HStack{
                    Button(action: getTheme){
                        Card(width: 150, height: 200, cornerRadius: 16, views:{ AnyView(themeCard)
                        })
                        .padding(10)
                            .frame(alignment: .leading)
                    }
                    Button(action: getStyle){
                            Card(width: 150, height: 200, cornerRadius: 16, views: { AnyView(styleCard)
                            })
                            .padding(10)
                            .frame(alignment: .trailing)
                    }
                }
                
                NavigationLink(destination: Clock(
                    time: timeDisplay,
                    theme: themeDisplay,
                    subject: subjectDisplay,
                    style: styleDisplay) ){
                    Card(views: {
                        AnyView(
                            Text("Start Drawing!")
                                .font(.system(size: 32))
                                .foregroundColor(AppTextColor)
                        )
                    })
                    .padding(.bottom)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .shadow(radius: 2)
                    }
                    .padding()
                    
            }
            
//            Button(action: getTime){
//                Text("Get a time limit!")
//            }.padding().buttonStyle(.bordered).foregroundColor(.white)
//                .font(.headline)
//                .padding(20)
//                .background(AppThemeColor)
//                .clipShape(Capsule())
//
//            Button(action: getTheme){
//                Text("Get a theme!")
//            }.padding().buttonStyle(.bordered).foregroundColor(.white)
//                .font(.headline)
//                .padding(20)
//                .background(AppThemeColor)
//                .clipShape(Capsule())
//
//            Button(action: getObject){
//                Text("Get a object!")
//            }.padding().buttonStyle(.bordered).foregroundColor(.white)
//                .font(.headline)
//                .padding(20)
//                .background(AppThemeColor)
//                .clipShape(Capsule())
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
        NavigationView {
            VStack{
                header
                
                suggestions
            }
        }
        .accentColor(AppThemeColor)
    }
    
    
    // return a random predefined time
    // TODO connect this to the database
    func getTime() {
        let times = ["1 Minute", "5 Minutes", "10 Minutes", "15 Minutes", "20 Minutes", "30 Minutes", "45 Minutes", "1 Hour", "2 Hours", "3 Hours", "1 Day"]
        timeDisplay = times.randomElement()!
    }
    
    // return a random predefined theme
    // TODO connect this to database
    func getTheme() {
        let themes = ["Cartoon", "Realist", "Impressionist", "Abstract", "Baroque", "Gothic", "Graffiti", "Renaissance"]
        themeDisplay = themes.randomElement()!
    }
    
    // return a random predefined object
    // TODO connect this to the database
    func getSubject() {
        let subjects = ["Human", "Fruit", "Building", "What's in front of you", "Landscape", "Nature", "Animal"]
        subjectDisplay = subjects.randomElement()!
    }
    
    // return a random predefined art style
    // TODO connect this to the database
    func getStyle() {
        let styles = ["Painting", "Sketch", "Greyscale", "Digital", "Ink", "Colored Pencil"]
        styleDisplay = styles.randomElement()!
    }
}
    


struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search().environmentObject(SearchQueries())
    }
}
