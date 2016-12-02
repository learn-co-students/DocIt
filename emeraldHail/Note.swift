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
    var uniqueID: String
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? String ?? "No Content"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        uniqueID = dictionary["uniqueID"] as? String ?? "No ID"
    }
    
    init(content: String, timestamp: String, uniqueID: String) {
        print("Creating an instance of Note")
        
        self.content = content
        self.timestamp = timestamp
        self.uniqueID = uniqueID
        
    }
    
    func serialize() -> [String : Any] {
        print("Serializing a Note")
        
        return ["content" : content,
                "timestamp" : timestamp,
                "uniqueID" : uniqueID,
                "postType" : "note"]
    }
    
    
}
