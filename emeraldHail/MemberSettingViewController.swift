//
//  MemberSettingViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MemberSettingViewController: UIViewController {

    // OUTLETS 
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var totalPost: UILabel!
    
    // LOADS 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

   // ACTIONS 
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSetting(_ sender: UIButton) {
        
    }
    
    // METHODS
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
