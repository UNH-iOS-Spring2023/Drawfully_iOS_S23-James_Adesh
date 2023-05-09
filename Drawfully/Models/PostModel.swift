//
//  PostImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
// Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI

// a modular implementation of user posts, used where any user generated image is shown
struct PostModel: Encodable, Decodable {
    var caption: String //The caption for the post
    var likes: [String:Bool] //Dictionary [(uid - String: true/false - boolean)] to keep track of who has liked a particular post. If a user unlikes a post after liking it, we set the boolean value to false
    var saves: [String:Bool]
    var ownerId: String //The user who has created that post
    var postId: String //The randomly generated UUID String used to store the post image
    var username: String //username of the user who has created the post
    var profileImageUrl: String //URL Link to profile picture of that user
    var mediaUrl: String //URL Link to the post ikmage
    var title: String //The title of the post
    var date: Double //Date/Timestap of the post
    var likeCount: Int //The number of likes that the post has. Basically number of elements in the "likes" Dictionary which has "true" value
    var isPublic: Bool //The post visibility

}

