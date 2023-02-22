//
//  PostImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct PostImage: View {
    var body: some View {
        let primaryColor:Color=Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)
        
        //Will write code for Post Image View here
        
        //Post Image UI Created
        VStack{
            Image("sample_drawing")
                .resizable()
                .frame(width: 380,height: 380)
                .aspectRatio(contentMode: .fill)
                .padding(3)
                .overlay(
                    Rectangle()
                        .stroke(primaryColor, lineWidth: 3)
                ).padding(10)
            
            HStack{
                Image(systemName: "heart").resizable().frame(width: 38,height: 38)
                Text("55").font(.title).fontWeight(.bold)
                
                Image(systemName: "text.bubble").resizable().frame(width: 38,height: 38)
                
                Text("4").font(.title).fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "bookmark")
                    .resizable().frame(width: 38,height: 38,alignment: .trailing)
            }.padding(15)
                .foregroundColor(primaryColor)
        }
    }

}

struct PostImage_Previews: PreviewProvider {
    static var previews: some View {
        PostImage()
    }
}
