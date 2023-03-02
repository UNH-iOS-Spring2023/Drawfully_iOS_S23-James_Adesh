//
//  Add.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Add: View {
    var body: some View {
        
        
    //Add title bar to Add Image Tab
        VStack{
            
            HStack{
                
                Spacer()
                Text("Add Image").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "magnifyingglass")
            }.padding()
            
            Spacer()
            
        }
        }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
    }
}
