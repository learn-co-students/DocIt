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
    var uniqueID: String
    var naturalTime: String?
    
    init(dictionary: [String : Any], symptomsToAdd: [String : Any], uniqueID: String) {
        
        content = symptomsToAdd as? [String : String] ?? ["No symptom" : "No symptom"]
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        self.uniqueID = uniqueID
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        
    }
    
    init(dictionary: [String : Any]) {
        
        content = dictionary["content"] as? [String : String] ?? ["No symptom" : "No symptom"]
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        uniqueID = dictionary["uniqueID"] as? String ?? "No Unique Post ID"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        
    }
    
    init(content: [String : String], uniqueID: String, timestamp: String) {
        print("Creating an instance of Symp")
        
        self.content = content
        self.uniqueID = uniqueID
        self.timestamp = timestamp
        
    }
    
    func serialize() -> [String : Any] {
        print("Serializing a Symp")
        
        return ["content" : content,
                "timestamp" : timestamp,
                "uniqueID" : uniqueID,
                "postType" : "symp",
                "naturalTime" : getNaturalTime()]
        
    }
    
    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ h:mma"
        
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
}
