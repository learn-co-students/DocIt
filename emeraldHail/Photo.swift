//
//  Photo.swift
//  emeraldHail
//
//  Created by Mirim An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//


import Foundation

struct Photo {
    
    // content is image URL
    var content: String
    var timestamp: String
    var naturalTime: String?
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? String ?? "No Photo URL"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        
    }
    
    init(content: String, timestamp: String) {
        print("Creating an instance of Photo")
        
        self.content = content
        self.timestamp = timestamp
        
    }
    
    func serialize() -> [String : Any] {
        print("Serializing a Photo")
        
        return ["content" : content,
                "timestamp" : timestamp,
                "postType" : "photo",
                "naturalTime" : getNaturalTime()]
        
    }
    
    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ hh:mma"
        
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
}
