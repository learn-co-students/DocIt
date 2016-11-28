//
//  Logics.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class Logics {
    
    // initializers
    
    private init() {}
//
//        guard let id = UserDefaults.value(forKey: "FamilyID") as? String else { return }
//        
//        family = Family(id: id)
//        
//        // family should be able to retrieve data based upon this id from firebase
//        
//        
//        
//        
//        
//        
//    
//    
//        
//        
//        
//    }
//    
    // properties
    
    static let sharedInstance = Logics()
    
    var family: Family!
    
    var familyID = ""
    var familyName = ""
    var familyPicture = ""
    
    var memberID = ""
    var eventID = ""
    var genderType = ""
    
    func clearDataStore() {
        
        familyID = ""
        familyName = ""
        familyPicture = ""
        
        memberID = ""
        eventID = ""
        genderType = ""
        
    }
    
}

