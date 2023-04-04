//
//  Search.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Search: View {
    var body: some View {
        
        //Add title bar to Search Tab
        
        // Nice looking header
        let header = VStack{
                
                HStack{
                    
                    Spacer()
                    Text("Search & Suggestions ").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                
                }.padding()
            }
        
        // After searching, show related users or Titles
        let dropdown = ScrollView{
            Text("User").padding(3)
            Text("User").padding(3)
            Text("User").padding(3)
        }
        
        // Show all the posts user has saved
        let posts = ScrollView {
            HStack{
                Text("Posts").padding()
                Text("Posts").padding()
                Text("Posts").padding()
            }.padding()
            HStack{
                Text("Posts").padding()
                Text("Posts").padding()
                Text("Posts").padding()
            }.padding()
            HStack{
                Text("Posts").padding()
                Text("Posts").padding()
                Text("Posts").padding()
            }.padding()
        }
        
        // Give random ideas from the database to the user
        let suggestions = HStack{
                Text("Get a Time Limit!").padding()
                Text("Get a Theme!").padding()
                Text("Get an Object!").padding()
            }
        
        // Make the body of the UI
        let body = VStack {
            Text("Search Bar").bold(true).underline()
            dropdown
            Divider()
            
            Text("Saved Posts").padding().bold(true).underline()
            posts
            Divider()
            
            Text("Suggestions")
            suggestions
        }
        
        
        // Display content
        VStack {
            header
            Divider()
            
            body
            Spacer()
        }
        }
    
    }


struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
