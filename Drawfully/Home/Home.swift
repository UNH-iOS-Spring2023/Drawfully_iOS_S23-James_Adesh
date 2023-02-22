//
//  Home.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        //Will write code for Home Tab View here
        //Added scroll view for user's images
        VStack{
            
            HStack{
                Image("streak").resizable().frame(width:30, height: 30)
                Text("14")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("Home").font(.title).fontWeight(.bold).padding(.trailing, 42.0).multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "magnifyingglass")
            }.padding()
            
            ScrollView{
                VStack{
                    HStack{
                        HomeImage()
                        HomeImage()
                        HomeImage()
                    }
                    HStack{
                        HomeImage()
                        HomeImage()
                        HomeImage()
                    }
                    
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
