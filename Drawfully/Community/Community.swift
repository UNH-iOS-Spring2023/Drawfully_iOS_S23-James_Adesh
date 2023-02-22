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
        ScrollView{
                    VStack{
                        PostImage()
                        PostImage()
                        PostImage()
                    }
                }
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
