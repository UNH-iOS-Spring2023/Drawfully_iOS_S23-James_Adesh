//
//  HomeImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct HomeImage: View {
    var body: some View {
        
        //Will write code for Home Image View here
        
        //Added Image View for Drawings
        //Using static image for structure of UI
        Image("sample_drawing")
                    .resizable()
                    .frame(width: 120,height: 120)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(30)
                    .padding(3)
                    .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274), lineWidth: 3)
                            
                        )
    }
}

struct HomeImage_Previews: PreviewProvider {
    static var previews: some View {
        HomeImage()
    }
}
