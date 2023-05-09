//
//  CommentView.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/17/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/EtnFlr1UcOI?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI

struct CommentView: View {
    @StateObject var commentService = CommentService()
    
    var post: PostModel
    var postId: String!
    
    var body: some View {
        VStack{
            ScrollView{
                if !commentService.comments.isEmpty{
                    ForEach(commentService.comments){
                        (comment) in
                        CommentCard(comment: comment)
                            .padding()
                        
                        Rectangle()
                            .fill(Color(UIColor.lightGray))
                            .frame(height:2)
                    }
                }
            }
            CommentInput(post: post, postId: postId)
        }
        .navigationTitle("Comments")
        
        .onAppear{
            self.commentService.postId = self.post == nil ? self.postId : self.post.postId
            
            self.commentService.loadComments()
        }
        .onDisappear{
            if self.commentService.listener != nil{
                self.commentService.listener.remove()
            }
        }
    }
}
