//
//  Event.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

final class Event {
    
    //event properties
//    var id: String
    var name: String
    var startDate: String
    var isComplete: Bool = false
//    var posts: [Post]
    
    //initializers
    init(name: String, startDate: String) {
        
//        self.id = id
        self.name = name
        self.startDate = startDate
//        self.posts = posts
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
//        id = snapshotValue["id"] as! String
        name = snapshotValue["name"] as! String
        startDate = snapshotValue["startDate"] as! String
//        posts = snapshotValue["posts"] as! [Post]
        
    }

    func serialize() -> [String : Any] {
        return  ["name" : name, "startDate": startDate, "isComplete": isComplete]
    }
    
}
