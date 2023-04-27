//
//  SwiftUIView.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/17/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/EtnFlr1UcOI?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI
import SDWebImageSwiftUI


struct CommentCard: View {
    var comment: CommentModel
    
    
    
    var body: some View {
        HStack{
            //Profile image of comment owner
            WebImage(url: URL(string: comment.profileImageUrl)!)
                .resizable()
                .placeholder(Image(systemName: "person.circle.fill"))
                .aspectRatio(contentMode: .fill)
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 30, height:30, alignment: .center)
                .shadow(color: .gray, radius: 3)
                .padding(.leading)
            
            
            VStack(alignment: .leading){
                //Username of comment owner
                Text(comment.username).font(.subheadline).bold()
                //Comment content
                Text(comment.comment).font(.caption)
            }
            Spacer()
            
            //Showing time since comment was posted
            Text((Date(timeIntervalSince1970: comment.date)).timeAgo() + " ago").font(.subheadline)
            
        }
    }
}

