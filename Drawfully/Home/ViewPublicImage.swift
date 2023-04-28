//
//  ViewPublicImage.swift
//  Drawfully
//
//  Created by James on 4/25/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Introspect

struct ViewPublicImage: View {
    var post: PostModel
    @State private var tabBar: UITabBar?
    @State private var fieldsEditable:Bool=false
    @State var title:String=""
    @State var caption:String=""
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all,edges: .all) // Black background
            
            // Fullscreen display of post image
            WebImage(url: URL(string : post.mediaUrl)!)
                .resizable()
                .scaledToFit()
            
            VStack{
                
                Spacer()
                HStack{
                    //Title display
                    Text(post.title)
                        .font(.body)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 50)
                    
                    Spacer()
                }
                HStack{
                    //Caption display
                    Text(post.caption)
                        .font(.caption)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }.padding()
            }
        }
    }
}
