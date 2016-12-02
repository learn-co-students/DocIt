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
    var naturalTime: String?
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? String ?? "No Content"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        
    }
    
    init(content: String, timestamp: String) {
        print("Creating an instance of Note")
        
        self.content = content
        self.timestamp = timestamp
        
    }
    
    func serialize() -> [String : Any] {
        print("Serializing a Note")
        
        return ["content" : content,
                "timestamp" : timestamp,
                "postType" : "note",
                "naturalTime" : getNaturalTime()]
        
    }
    
    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ hh:mma"
        
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
}
