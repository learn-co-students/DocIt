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

struct Member {
    
    var profileImage: String = ""
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var gender: String
    var birthday: String
    var uniqueID: String
    
    
    init(profileImage: String, firstName: String, lastName: String, gender: String, birthday: String, uniqueID: String = "") {
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





//final class Member {
//    
//    //member properties
//    var id: String
//    var firstName: String
//    var lastName: String
//    var profileImage: UIImage?
//    var profileImageStr: String?
//    var gender: Gender
//    var height: Double
//    var weight: Double
//    var bloodType: BloodType
//    var events: [Event]
//    
//    //initializers
//    init(id: String, firstName: String, lastName: String, profileImage: UIImage?, profileImageStr: String?, gender: Gender, height: Double, weight: Double, bloodType: BloodType, events: [Event]) {
//        
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.profileImage = profileImage
//        self.profileImageStr = profileImageStr
//        self.gender = gender
//        self.height = height
//        self.weight = weight
//        self.bloodType = bloodType
//        self.events = events
//        
//    }
//    
//}
