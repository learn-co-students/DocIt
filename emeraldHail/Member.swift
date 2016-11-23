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



final class Member {
    
    var profileImage: String?
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var gender: String
    var birthday: String
    var uniqueID: String
    
    var image: UIImage?
    
    var isDownloadingImage: Bool = false
    
    
    
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
        
        profileImage = snapshotValue["profileImage"] as? String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        birthday = snapshotValue["dob"] as! String
        gender = snapshotValue["gender"] as! String
        uniqueID = snapshotValue["uniqueID"] as! String
        
    }
    
    func serialize() -> [String : Any] {
        return  ["firstName" : firstName, "lastName": lastName, "gender" : gender, "dob" : birthday, "uniqueID" : uniqueID, "profileImage" : profileImage ?? ""]
    }
}

// MARK: - Downloading Image
extension Member {
    
    func downloadProfileImage(at urlString: String, handler: @escaping (Bool, UIImage?) -> Void) {
        
        isDownloadingImage = true
        
        guard let url = URL(string: urlString) else { handler(false, nil); return }
        
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request, completionHandler: { [unowned self] data, response, error in
            
            DispatchQueue.main.async {
                
                guard let rawData = data, let image = UIImage(data: rawData) else { handler(false, nil); return }
                
                self.image = image
                
                self.isDownloadingImage = false
                
                handler(true, image)
                
            }
            
        }).resume()
    }
}



extension Member: Equatable {
    
    static func ==(lhs: Member, rhs: Member) -> Bool {
        
        return lhs.uniqueID == rhs.uniqueID
    }
    
    
    
}
