//
//  Event.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Event {
    
    // properties
    
    var name: String
    var startDate: String
    var isComplete: Bool = false
    var uniqueID: String
    
    // initializers
    
    init(name: String, startDate: String, uniqueID: String = "") {
        
        self.name = name
        self.startDate = startDate
        self.uniqueID = uniqueID
        
    }
    
    init(dictionary: [String : Any], uniqueID: String) {
        name = dictionary["name"] as? String ?? "No name"
        startDate = dictionary["startDate"] as? String ?? "No start date"
        
        self.uniqueID = uniqueID
    }

    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
//        id = snapshotValue["id"] as! String
        name = snapshotValue["name"] as! String
        startDate = snapshotValue["startDate"] as! String
        uniqueID = snapshotValue["uniqueID"] as! String
//        posts = snapshotValue["posts"] as! [Post]
        
    }

    func serialize() -> [String : Any] {
        return  ["name" : name, "startDate": startDate, "isComplete" : isComplete, "uniqueID": uniqueID]
    }
    
}
