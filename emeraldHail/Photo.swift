//
//  Photo.swift
//  emeraldHail
//
//  Created by Mirim An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//


import Foundation

struct Photo {
    
    var content: String
    // content is image URL
    var timestamp: String
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? String ?? "No Photo URL"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        
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
                "postType" : "photo"]
    }
    
}
