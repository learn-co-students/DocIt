//
//  Photo.swift
//  emeraldHail
//
//  Created by Mirim An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//


import Foundation

struct Photo {
    
    var content: String // Content is image URL
    var timestamp: String
    var uniqueID: String
    var naturalTime: String?
    
    init(dictionary: [String : Any]) {
        content = dictionary["content"] as? String ?? "No Photo URL"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        uniqueID = dictionary["uniqueID"] as? String ?? "No UniqueID"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
    }
    
    init(content: String, timestamp: String, uniqueID: String) {
        self.content = content
        self.timestamp = timestamp
        self.uniqueID = uniqueID
    }
    
    func serialize() -> [String : Any] {
        return ["content" : content,
                "timestamp" : timestamp,
                "uniqueID" : uniqueID,
                "postType" : "photo",
                "naturalTime" : getNaturalTime()]
    }
    
    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ h:mma"
        
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
}
