//
//  Community.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Community: View {
    var body: some View {
        
        //Will write code for Community Tab View here
        VStack {
            
            HStack{
                Text("Community").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "magnifyingglass")
            }.padding()
            
            ScrollView{
                        VStack{
                            PostImage()
                            PostImage()
                            PostImage()
                        }
            }
        }
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
