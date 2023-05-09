//
//  UserModel.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/2/23.
// Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation
import Firebase
import FirebaseFirestore

// stored in the user session, stores all relevant data for the user
struct User: Encodable, Decodable{
    var uid:String //FirebaseAuth generated uid
    var email: String //Email of that user
    var profileImageUrl:String //URL to the profile picture stored in Cloud Storage
    var username:String //username of the user
    var lastUpdated: String
//    var searchName:[String] //Dictionary of split strings of username. Created to make implementation of search quicker and easier
    var streak:Int //Current streak of that user
    var firstName: String //First name of the user
    var lastName: String //Last Name of the user
    //var drawingsRef: [DocumentReference]
    
    
    //var bio:String
}
