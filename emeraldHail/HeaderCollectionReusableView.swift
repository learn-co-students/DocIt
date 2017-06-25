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
import SDWebImage

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var darkOverlay: UIView!
    
    let store = DataStore.sharedInstance
    let database = FIRDatabase.database().reference()
    
    func configDatabaseFamily() {
        let familyRef = Database.family.child(Store.userFamily)
        familyRef.observe(.value, with: { snapshot in
            var dic = snapshot.value as! [String : Any]
            let imageString = dic["coverImageStr"] as! String
            let profileImgUrl = URL(string: imageString)
            self.profileImage.sd_setImage(with: profileImgUrl)
        })
    }
}
