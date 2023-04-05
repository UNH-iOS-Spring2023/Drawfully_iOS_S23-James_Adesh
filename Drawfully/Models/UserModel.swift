//
//  UserModel.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/2/23.
// Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation

struct User: Encodable, Decodable{
    var uid:String
    var email: String
    var profileImageUrl:String
    var username:String
    var searchName:[String]
    var streak:Int
    var firstName: String
    var lastName: String
    
    
    //var bio:String
}
