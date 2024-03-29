//
//  PostCard.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/6/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/M0OrDT7iXJY?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI

struct PostCard: View {
    
    @ObservedObject var postCardService = PostCardService()
    
    @ObservedObject var commentService = CommentService()
    
    //animate boolean variable to trigger animation on  'Like' button
    @State private var animateLike = false
    @State private var animateSave = false
    
    //duration of animation on clicking of 'Like' button
    private let duration: Double = 0.3
    
    //animation scale of 'Like' button. Once clicked, it gets bigger and then smaller
    private var animationScale: CGFloat{
        postCardService.isLiked ? 1.0 : 2.0
        //postCardService.isSaved ? 1.0 : 2.0
        
    }
    
    //Initializing post and like status (whether liked or not)
    init(post: PostModel){
        self.postCardService.post = post
        self.postCardService.hasLikedPost()
        self.postCardService.hasSavedPost()
        self.commentService.getCommentsCount(postId: post.postId)
    }
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 15){
                Button(action: {
                    self.animateLike=true
                    DispatchQueue.main.asyncAfter(deadline: .now()+self.duration, execute: {
                        self.animateLike = false
                        if (self.postCardService.isLiked){
                            self.postCardService.unlike()
                        }
                        else
                        {
                            self.postCardService.like()
                        }
                    })
                }) {
                    //Filled red heart when post is liked else black heart(not filled)
                    Image(systemName: (self.postCardService.isLiked) ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25,height: 25, alignment: .center)
                        .foregroundColor((self.postCardService.isLiked) ? .red : .black)
                }.padding().scaleEffect(animateLike ? animationScale : 1)
                    .animation(.easeIn(duration: duration))
                
                NavigationLink(destination: CommentView(post:self.postCardService.post)){
                    //Comments button
                    Image(systemName: "bubble.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25,height: 25, alignment: .center)
                    
                    //Number of comments displayed if the post has comments. If 0 comments, number is not displayed
                    if !(self.commentService.documentCount==0){
                        Text(String(self.commentService.documentCount))}
                }
                
                Spacer()
                Button(action: {
                    self.animateSave=true
                    DispatchQueue.main.asyncAfter(deadline: .now()+self.duration, execute: {
                        self.animateSave = false
                        if (self.postCardService.isSaved){
                            self.postCardService.unsave()
                        }
                        else
                        {
                            self.postCardService.save()
                        }
                    })
                }){
                    Image(systemName: (self.postCardService.isSaved) ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25,height: 25, alignment: .center)
                        .foregroundColor((self.postCardService.isSaved) ? AppThemeColor : .black)
                       // .padding(.trailing,30)
                }.padding().scaleEffect(animateSave ? animationScale : 1)
                    .animation(.easeIn(duration: duration))
                
            }.padding(.leading, 16)
            
            
            //Number of likes displayed after post
            if (self.postCardService.post.likeCount > 0) {
                
                Text ("\(self.postCardService.post.likeCount) likes").padding(.leading)
                
            }
            //Clickable text to view comments. To be implemented
            NavigationLink(destination: CommentView(post:self.postCardService.post)){
                Text("View Comments").font(.caption).padding(.leading)
            }
        }
    }
}
