//
//  PostImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct PostModel: View, Encodable, Decodable {
//    var caption: String
//    var likes: [String:Bool]
//    var ownerId: String
//    var postId: String
//    var username: String
//    var profile: String
//    var mediaUrl: String
//    var date: Double
//    var likeCount: Int
    
    var body: some View {
        let primaryColor:Color=Color(red: 0.0, green: 0.6078431372549019, blue: 0.5098039215686274)
        
        //Will write code for Post Image View here
        
        //Post Image UI Created
        VStack{
            Image("sample_drawing")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 360,height: 262)
                .padding()
                .overlay(
                    Rectangle()
                        .stroke(primaryColor, lineWidth: 3)
                )
            
            HStack{
                Image(systemName: "heart").resizable().frame(width: 38,height: 38)
                Text("55").font(.title).fontWeight(.bold)
                
                Image(systemName: "text.bubble").resizable().frame(width: 38,height: 38)
                
                Text("4").font(.title).fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "bookmark")
                    .resizable().frame(width: 38,height: 38,alignment: .trailing)
            }
                
                .foregroundColor(primaryColor)
        }.frame(width: 399,height: 329)
            .padding(10)
    }

}

struct PostImage_Previews: PreviewProvider {
    static var previews: some View {
        PostModel()
    }
}
