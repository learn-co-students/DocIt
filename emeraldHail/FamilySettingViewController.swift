//
//  FamilySettingViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FamilySettingViewController: UIViewController {
    
    let store = Logics.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // TODO: When the logout button is pressed, it takes you back to the sign in screen, but the text fiels still have user information there. We should clear that out or figure out how to proceed in that situation.
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func changeFamilyNamePressed(_ sender: Any) {
        changeFamilyName()
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
        present(alert, animated: true, completion: nil)
    }
    
}
