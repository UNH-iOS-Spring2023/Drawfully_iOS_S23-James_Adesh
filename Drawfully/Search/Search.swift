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
        
        let header = VStack{
                
                HStack{
                    
                    Spacer()
                    Text("Search & Suggestions ").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                
                }.padding()
            }
        
        let dropdown = ScrollView{
            Text("User").padding(3)
            Text("User").padding(3)
            Text("User").padding(3)
        }
        
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
        
        let suggestions = HStack{
                Text("Get a Time Limit!").padding()
                Text("Get a Theme!").padding()
                Text("Get an Object!").padding()
            }
        
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
