//
//  Person.swift
//  emeraldHail
//
//  Created by Emerald Hail on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit


struct Person {
    
    var id: String
    var familyId: String
    var email: String
    
    init(id: String, familyId: String, email: String) {
        
        self.id = id
        self.familyId = familyId
        self.email = email
        
    }
    
}



enum BloodType: String {
    case OPos = "O+", ONeg = "O-", APos = "A+", ANeg = "A-", BPos = "B+", BNeg = "B-", ABPos = "AB+", ABNeg = "AB-"
}

enum Gender: String {
    case female = "Female", male = "Male", other = "Not specified"
}

