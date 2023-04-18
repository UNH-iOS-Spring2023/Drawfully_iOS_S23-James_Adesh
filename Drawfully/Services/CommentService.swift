//
//  CommentService.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/14/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation :https://youtu.be/i9ZIPGpPENw?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-


import Foundation
import Firebase


class CommentService: ObservableObject {
    
    @Published var isLoading = false
    @Published var comments: [CommentModel] = []
    var postId: String!
    var listener: ListenerRegistration!
    var post: PostModel!

    
    
    static var commentsRef = AuthService.storeRoot.collection("comments")
    
    static func commentsId(postId: String)->DocumentReference {
        return commentsRef.document(postId)
    }
    
    func postComment(comment: String, username: String, profileImageUrl: String, ownerId: String, postId: String, onSuccess: @escaping()->Void, onError:@escaping(_ error: String)->Void){
        
        let comment = CommentModel(profileImageUrl: profileImageUrl, postId: postId, username: username, date: Date().timeIntervalSince1970, comment: comment, ownerId: ownerId)
        guard let dict = try? comment.asDictionary()
        else{
            return
        }
        
        CommentService.commentsId(postId: postId).collection("comments").addDocument(data: dict){
            (err) in
            if let err = err{
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
        
    }
    
    func getComments(postId: String, onSuccess: @escaping ([CommentModel])-> Void, onError: @escaping(_ error: String)-> Void, newComment: @escaping(CommentModel) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration)-> Void )
    {
        let listenerPosts = CommentService.commentsId(postId: postId).collection("comments").order(by: "date", descending: false).addSnapshotListener{
            (snapshot, err) in
            guard let snapshot = snapshot else {return}
            
            var comments = [CommentModel]()
            
            snapshot.documentChanges.forEach{
                (diff) in
                
                if (diff.type == .added){
                    let dict = diff.document.data()
                    guard let decoded = try? CommentModel.init(fromDictionary: dict) else {
                        return
                    }
                    
                    newComment(decoded)
                    comments.append(decoded)
                    
                }
                
                if (diff.type == .modified)
                {
                    print("Modify comment")
                    //TODO
                }
                if (diff.type == .removed)
                {
                    print("Remove comment")
                    //TODO
                }
            }
            
            onSuccess(comments)
        }
        listener(listenerPosts)
        
        
    }
    
    
    func loadComments() {
        self.comments = []
        self.isLoading = true
        self.getComments(postId: postId, onSuccess: {
            (comments) in
            if self.comments.isEmpty {
                self.comments = comments
            }
        }, onError: {
            (err) in
            print("Error loading comments : ", err)
        },
            newComment: {
            (comment) in
            if !self.comments.isEmpty{
                self.comments.append(comment)
        }
        }){
            (listener) in
            self.listener = listener
        }
    }
    
    
    func addComment(comment: String, onSuccess: @escaping()-> Void){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        guard let username = Auth.auth().currentUser?.displayName else { return}
        
        guard let profileImageUrl = Auth.auth().currentUser?.photoURL?.absoluteString else { return}
        
        postComment(comment: comment, username: username, profileImageUrl: profileImageUrl, ownerId: currentUserId, postId: post.postId, onSuccess: {onSuccess()})
        {
            (err) in
            print("Error adding comments : ", err)
        }
        
        
    }
}
