//
//  CommentModel.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/14/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Citation :https://youtu.be/i9ZIPGpPENw?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-


import Foundation

// a class for comments for modular use
struct CommentModel: Encodable, Decodable, Identifiable {
    
    //Creating a unique identifier
    var id = UUID()
    
    var profileImageUrl: String
    var postId: String
    var username: String
    var date:Double
    var comment: String
    var ownerId: String
    
}
