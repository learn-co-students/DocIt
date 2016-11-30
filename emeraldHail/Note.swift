//
//  Note.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

struct Note {
    
    var content: String
    var timestamp: String
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? String ?? "No Content"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        
        
    }
    
    init(content: String, timestamp: String) {
        
        self.content = content
        self.timestamp = timestamp
        
    }
    
    func serialize() -> [String : Any] {
        
        return ["content" : content,
                "timestamp" : timestamp,
                "postType" : "note"]
    }
    
}
