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
    
    func serialize() -> [String : Any] {
        
        return ["content" : content,
                "timestamp" : timestamp,
                "postType" : "note"]
    }
    
    
    
}


