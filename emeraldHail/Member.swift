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
    var gender: String
    var birthday: String
    var bloodType: String
    var height: String
    var weight: String
    var allergies: String
    var id: String
    
    init(profileImage: String, firstName: String, lastName: String, gender: String , birthday: String,  bloodType: String, height: String, weight: String, allergies: String, id: String) {
        self.profileImage = profileImage
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        self.bloodType = bloodType
        self.height = height
        self.weight = weight
        self.allergies = allergies
        self.id = id
    }
    
    init(dictionary: [String : Any], id: String) {
        profileImage = dictionary["profileImage"] as? String ?? "No Image URL"
        firstName = dictionary["firstName"] as? String ?? "No Name"
        lastName = dictionary["lastName"] as? String ?? "No Last Name"
        gender = dictionary["gender"] as? String ?? "No Gender"
        birthday = dictionary["birthday"] as? String ?? "No Birthday"
        bloodType = dictionary["bloodType"] as? String ?? "No Blood Type"
        height = dictionary["height"] as? String ?? "No Height"
        weight = dictionary["weight"] as? String ?? "No Weight"
        allergies = dictionary["allergies"] as? String ?? "No Allergies"
        
        self.id = id
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as? [String : AnyObject]
        
        profileImage = snapshotValue?["profileImage"] as? String ?? "No Image URL"
        firstName = snapshotValue?["firstName"] as? String ?? "No First Name"
        lastName = snapshotValue?["lastName"] as? String ?? "No Last Name"
        gender = snapshotValue?["gender"] as? String ?? "No Gender"
        birthday = snapshotValue?["birthday"] as? String ?? "No Birthday"
        bloodType = snapshotValue?["bloodType"] as? String ?? "No Bloodtype"
        height = snapshotValue?["height"] as? String ?? "No Height"
        weight = snapshotValue?["weight"] as? String ?? "No Weight"
        allergies = snapshotValue?["allergies"] as? String ?? "No Allergies"
        id = snapshotValue?["uniqueID"] as? String ?? "No ID"
    }
    
    func serialize() -> [String : Any] {
        return  ["profileImage" : profileImage, "firstName" : firstName, "lastName": lastName, "gender" : gender, "birthday" : birthday,  "bloodType": bloodType, "height": height, "weight": weight, "allergies": allergies,  "uniqueID" : id]
    }
    
    func saveToFireBase(handler: (Bool) -> Void) {
        // TODO:
        // get the firebase ref through the shared manager
        // updateValue should be called but on the right ref. child("VALUE") replacing value with the correct location
        // call update value on that ref then in that completion handler of that, if successfull, call handler here and pass in true.
    }
    
}
