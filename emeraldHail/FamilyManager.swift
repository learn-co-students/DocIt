//
//  FamilyManager.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation


final class FamilyManager {
    
    static let shared = FamilyManager()
    
    private init() { }
    
    var familyID: String?
    var members: [Member] = []
    var familyName: String?
    var familyPhoto: UIImage?
    var posts: [Event : [Post]]?
    
    func createFamily(with id: String, handler: (Bool) -> Void) {
        familyID = id
        
        // TODO: Go to firebase, get more stuff!
        // TODO: Get the members and populate the members array
    }
    
}
