//
//  Extensions.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 3/31/23.
// Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation

extension Encodable{
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder ( ) . encode (self)
        
        guard let dictionary = try JSONSerialization.jsonObject (with: data, options: .allowFragments) as? [String: Any]
        else {
            throw NSError ()
        }
        return dictionary
    }
}

extension Decodable{
    init(fromDictionary: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: fromDictionary, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
    
}

extension String{
    func splitString() -> [String] {
        var stringArray: [String] = []
        let trimmed = String(self.filter { !"\n\t\r".contains($0)})
        for (index, _) in trimmed.enumerated(){
            let prefixIndex = index+1
            let substringPrefix = String(trimmed.prefix(prefixIndex)).lowercased()
            stringArray.append(substringPrefix)
        }
        return stringArray
    }
}


//Citation :  ChatGPT
//extension Array {
//    func chunks(of chunkSize: Int) -> [[Element]] {
//        return stride(from: 0, to: self.count, by: chunkSize).map {
//            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
//        }
//    }
//}
