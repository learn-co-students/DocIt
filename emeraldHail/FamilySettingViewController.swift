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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
    
    // TODO: When the logout button is pressed, it takes you back to the sign in screen, but the text fiels still have user information there. We should clear that out or figure out how to proceed in that situation.
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }

}
