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
            VStack{
                
                HStack{
                    
                    Spacer()
                    Text("Search & Suggestions ").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                
                }.padding()
                
                Spacer()
                
            }
            }
    }


struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
