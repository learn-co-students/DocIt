//
//  Event.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

final class Event {
    
    var id: String
    var name: String
    var startDate: Date
    var isComplete: Bool = false
    var posts: [Post]
    
    init(id: String, name: String, startDate: Date, posts: [Post]) {
        
        self.id = id
        self.name = name
        self.startDate = startDate
        self.posts = posts
        
    }
    
}
