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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
