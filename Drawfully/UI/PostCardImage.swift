//
//  PostCardImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/6/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/J1fd-b8vnpQ?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI

import SDWebImageSwiftUI



struct PostCardImage: View {
    
    var post: PostModel
    
    
    var body: some View {

        VStack(alignment: .leading) {
            HStack{
                //Profile image of owner of post
                WebImage(url: URL(string: post.profile)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60, alignment: .center)
                    .shadow(color:.gray,radius: 3)
                
                //username of owner displayed
                VStack(alignment: .leading, spacing: 4){
                    //username  of owner of post
                    Text(post.username).font(.headline)
                    Text((Date(timeIntervalSince1970: post.date)).timeAgo()+" ago").font(.subheadline)
                        .foregroundColor(.gray)
                    
                }.padding(.leading, 10)
            }.padding(.leading)
                .padding(.top, 16)
            
            //Title to be displayed. TODO
            //Caption of post
            Text(post.caption).lineLimit(nil)
                .padding(.leading, 16)
                .padding(.trailing, 32)
            
            //Image posted as drawing is displayed
            WebImage(url: URL(string: post.mediaUrl)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
                .clipped()
        }
    }
}

