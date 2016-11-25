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
    
    func changeFamilyName() {
        let alert = UIAlertController(title: nil, message: "Change your family name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let userInput = alert.textFields![0].text
            let ref = FIRDatabase.database().reference().child("family").child(self.store.familyID)
            
            guard let name = userInput, name != "" else { return }
            
            ref.updateChildValues(["name": name], withCompletionBlock: { (error, dataRef) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.textFields![0].placeholder = store.familyName
        alert.addAction(okAction)
        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
    }
    
}
