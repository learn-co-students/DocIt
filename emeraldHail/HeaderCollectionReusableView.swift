//
//  HeaderCollectionReusableView.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/25/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HeaderCollectionReusableView: UICollectionReusableView {

    let store = Logics.sharedInstance
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func addFamilyMemberPressed(_ sender: Any) {
        print("addFamilyMemberPressed")
    }
    
}
