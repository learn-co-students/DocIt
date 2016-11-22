//
//  Family.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Family {
    
    //family properties
    var id: String?
    var name: String?
    var email: String?
    var coverImage: UIImage?
    var coverImageStr: String?
    var members: [Member]?
    
    // initializers
    init(id: String, name: String, email: String, coverImage: UIImage?, coverImageStr: String?, members: [Member]?) {
        
        self.id = id
        self.name = name
        self.email = email
        self.coverImage = coverImage
        self.coverImageStr = coverImageStr
        self.members = []
    
    }
    
    init(name: String) {
        self.name = name
    }
    
//    init(snapshot: FIRDataSnapshot) {
//        
//        let snapshotValue = snapshot.value as! String : AnyObject]
//        
//        name = snapshotValue["name"] as! String
//
//    }
    
    func serialize() -> [String:Any] {
        return ["email":email!, "name":name!]
    }

}
