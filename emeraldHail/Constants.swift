//
//  Constants.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Constants {
    
    struct Colors {
        static let desertStorm = UIColor(red: 0.98, green: 0.97, blue: 0.97, alpha: 1.00)
        static let scooter = UIColor(red: 0.13, green: 0.75, blue: 0.89, alpha: 1.00)
        static let cinnabar = UIColor(red: 0.89, green: 0.26, blue: 0.21, alpha: 1.00)
        static let neonCarrot = UIColor(red: 0.99, green: 0.61, blue: 0.22, alpha: 1.00)
        static let ufoGreen = UIColor(red: 0.16, green: 0.77, blue: 0.40, alpha: 1.00)
        static let purpleCake = UIColor(red: 0.61, green: 0.35, blue: 0.71, alpha: 1.00)
        static let submarine = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00)
        static let athensGray = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
        static let corn = UIColor(red: 0.94, green: 0.74, blue: 0.07, alpha: 1.00)
        static let transBlack = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)
    }
    
    struct CustomCell {
        static let offset: CGFloat = 40.0
        static let bulletRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 1.0
        static let lineColor: CGColor = Constants.Colors.athensGray.cgColor
    }
}

public struct Database {
    static let url = "gs://emerald-860cb.appspot.com"
    static let events = FIRDatabase.database().reference().child("events")
    static let family = FIRDatabase.database().reference().child("family")
    static let members = FIRDatabase.database().reference().child("members")
    static let posts = FIRDatabase.database().reference().child("posts")
    static let settings = FIRDatabase.database().reference().child("settings")
    static let user = FIRDatabase.database().reference().child("user")
    static let storageFamily = FIRStorage.storage().reference(forURL: Database.url).child("familyImages")
    static let storagePosts = FIRStorage.storage().reference(forURL: Database.url).child("postsImage")
    static let storageProfile = FIRStorage.storage().reference(forURL: Database.url).child("profileImages")
}
