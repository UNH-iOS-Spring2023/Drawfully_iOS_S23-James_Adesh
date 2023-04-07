//
//  PostImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
// Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import SwiftUI

struct PostModel: Encodable, Decodable {
    var caption: String
    var likes: [String:Bool]
    var ownerId: String
    var postId: String
    var username: String
    var profile: String
    var mediaUrl: String
    var title: String
    var date: Double
    var likeCount: Int
    var isPublic: Bool

}

