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
    var id: String
    var name: String?
    var email: String?
    var coverImage: UIImage?
    var coverImageStr: String?
    var members: [Member]?
    
    init(id: String) {
        
        self.id = id
        
    }
    
    // initializers
    init(id: String, name: String, email: String, coverImage: UIImage?, coverImageStr: String?, members: [Member]?) {
        
        self.id = id
        self.name = name
        self.email = email
        self.coverImage = coverImage
        self.coverImageStr = coverImageStr
        self.members = []
        
    }
    
    init(name: String, id: String = "") {
        self.name = name
        self.id = id
    }
    
    init(coverImageStr: String, id: String = "") {
        self.coverImageStr = coverImageStr
        self.id = id
        
    }
    
    func changeImage(to imageStr: String) {
        
        
        self.coverImageStr = imageStr
        
    }
    
    //    init(snapshot: FIRDataSnapshot) {
    //
    //        let snapshotValue = snapshot.value as! String : AnyObject]
    //
    //        name = snapshotValue["name"] as! String
    //
    //    }
    // TODO: Why are we forcing this? Enrique
    func serialize() -> [String:Any] {
        return ["email":email!, "name":name!, "coverImageStr": coverImageStr!]
    }
    
}

// MARK: - Update Functions
extension Family {
    
    func updateName(to name: String) {
        
        self.name = name
        
    }
    
    func updateCoverPhotoStr(to imageStr: String) {
        
        self.coverImageStr = imageStr
        
    }
    
}


// MARK: - Firebase Methods
extension Family {
    
    func getFamilyMetaData(handler: (Bool) -> Void) {
        
        
        
        
        
        
        
        
        
        downloadProfileImage { success, image in
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func getMembersFromFamily(handler: (Bool) -> Void) {
        
        
        
        
        
        // loop through the array of members and for each one download their image.
        // The member object itself should be able to download their own image.
        
        
        
        
    }
    
    
}

// MARK: - Download Functions
extension Family {
    
    func downloadProfileImage(handler: (Bool, UIImage?) -> Void) {
        
        
        
    }
    
    
    
}
