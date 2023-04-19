//
//  CommentInput.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/17/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation : https://youtu.be/EtnFlr1UcOI?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI
import SDWebImageSwiftUI

struct CommentInput: View {
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var commentService = CommentService()
    @State private var text: String = ""
    
    
    //Initialising with a post
    init(post: PostModel?, postId: String?) {
        
        //If not post has been fetched, first fetch a post
        if post != nil{
            commentService.post = post
            
        }
        else{
            handleInput(postId: postId!)
        }
    }
    
    
    //Getting post reference to add comment
    func handleInput(postId: String){
        PostService.loadPost(postId: postId){
            post in
            //Fetching post related to the comment
            self.commentService.post = post
        }
    }
    
    //Sending and resetting comment
    func sendComment() {
        if !text.isEmpty {
            commentService.addComment(comment: text){
                self.text = ""
            }
        }
    }
    
    var body: some View {
        HStack(){
            WebImage(url: URL(string: session.session?.profileImageUrl ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50, height:50, alignment: .center)
                .shadow(color: .gray, radius: 3)
                .padding(.leading)
            
            HStack{
                TextEditor(text: $text)
                    .frame(height: 50)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 8, style: .circular).stroke(Color.black, lineWidth: 2))
                
                Button(action: sendComment) {
                    Image(systemName: "paperplane").imageScale(.large).padding(.trailing)
                }
                
            }
        }
            
    }
}
