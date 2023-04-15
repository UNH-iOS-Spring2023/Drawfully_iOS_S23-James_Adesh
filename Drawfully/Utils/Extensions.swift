//
//  Extensions.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 3/31/23.
//  Citation : The entire class is implemented with reference to the YouTube tutorial series - SwiftUI Instagram Clone with Firebase by iosMastery
//  Encoder, Decoder and splitString : Citation : https://youtu.be/GMxo8MA6Nnc?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-
//  timeAgo : Citation : https://youtu.be/M0OrDT7iXJY?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
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
//https://youtu.be/M0OrDT7iXJY?list=PLdBY1aYxSpPVI3wTlK1cKHNOoq4JA3X5-
//Extension to return how much time it has been since the post was made. Example -  "15 mins ago" or "1 day ago"
extension Date {
    func timeAgo()-> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year,.month,.day,.hour,.minute,.second]
        
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
        
    }
}
