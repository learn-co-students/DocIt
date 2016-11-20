//
//  Member.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

final class Member {
    
    //member properties
    var id: String
    var firstName: String
    var lastName: String
    var profileImage: UIImage?
    var profileImageStr: String?
    var gender: Gender
    var height: Double
    var weight: Double
    var bloodType: BloodType
    var events: [Event]
    
    //initializers
    init(id: String, firstName: String, lastName: String, profileImage: UIImage?, profileImageStr: String?, gender: Gender, height: Double, weight: Double, bloodType: BloodType, events: [Event]) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        self.profileImageStr = profileImageStr
        self.gender = gender
        self.height = height
        self.weight = weight
        self.bloodType = bloodType
        self.events = events
        
    }
    
}
