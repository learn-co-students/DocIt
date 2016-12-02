//
//  Symp.swift
//  emeraldHail
//
//  Created by Henry Ly on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

struct Symp {
    
    var content: [String : String]
    var timestamp: String
    var naturalTime: String?
    
    init(dictionary: [String : Any], symptomsToAdd: [String : Any]) {
        
        content = symptomsToAdd as? [String : String] ?? ["No symptom" : "No symptom"]
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        
    }
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? [String : String] ?? ["No symptom" : "No symptom"]
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        
    }
    
    init(content: [String : String], timestamp: String) {
        print("Creating an instance of Symp")
        
        self.content = content
        self.timestamp = timestamp
        
    }
    
    func serialize() -> [String : Any] {
        print("Serializing a Symp")
        
        return ["content" : content,
                "timestamp" : timestamp,
                "postType" : "symp",
                "naturalTime" : getNaturalTime()]
        
    }
    
    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ hh:mma"
        
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
}
