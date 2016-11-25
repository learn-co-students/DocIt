//
//  Member.swift
//  addMembers
//
//  Created by Mirim An on 11/19/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct Member {

    var profileImage: String
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var gender: String
    var birthday: String
    var uniqueID: String
    
    
    init(profileImage: String, firstName: String, lastName: String, gender: String , birthday: String, uniqueID: String = "") {
        self.profileImage = profileImage
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        self.uniqueID = uniqueID
        
    }
    
    init(dictionary: [String : Any], uniqueID: String) {
        profileImage = dictionary["profileImage"] as? String ?? "No Image URL"
        firstName = dictionary["firstName"] as? String ?? "No Name"
        lastName = dictionary["lastName"] as? String ?? "No Last Name"
        birthday = dictionary["dob"] as? String ?? "No Birthday"
        gender = dictionary["gender"] as? String ?? "No Gender"
        //userImage = dictionary["UserImage"] as? String ?? "No URL"
        
        self.uniqueID = uniqueID
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        profileImage = snapshotValue["profileImage"] as! String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        birthday = snapshotValue["dob"] as! String
        gender = snapshotValue["gender"] as! String
        uniqueID = snapshotValue["uniqueID"] as! String
        
    }
    
    func serialize() -> [String : Any] {
        return  ["firstName" : firstName, "lastName": lastName, "gender" : gender, "dob" : birthday, "uniqueID" : uniqueID, "profileImage" : profileImage]
    }
}
