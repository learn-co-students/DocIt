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
    
    // MARK: - Outlets
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    
    // MARK: - Methods 
    
    func configDatabaseFamily() {
        let membersRef = FIRDatabase.database().reference().child(Constants.DatabaseChildNames.family)
        let familyRef = membersRef.child(store.family.id)
        
        familyRef.observe(.value, with: { snapshot in
            var dic = snapshot.value as! [String : Any]
            
            let imageString = dic["coverImageStr"] as! String
            
            let profileImgUrl = URL(string: imageString)
            self.profileImage.sd_setImage(with: profileImgUrl)
        })
    }
    
}
