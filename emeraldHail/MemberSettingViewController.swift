//
//  MemberSettingViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class MemberSettingViewController: UIViewController {
    
    
    
    // OUTLETS
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var totalPost: UILabel!
    
    // PROPERTIES
    
    let store = Logics.sharedInstance
    
    // LOADS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPicture()
        displayMemberProfileEdits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayMemberProfileEdits()
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
    
    
    // Mark: blood type is not recorded
    func displayMemberProfileEdits() {
        let member = FIRDatabase.database().reference().child("members").child(store.familyID).child(store.memberID)
        
        member.observe(.value, with: { (snapshot) in
            //  print(snapshot.value)
            
            let value = snapshot.value as! [String : Any]
            let firstName = value["firstName"] as! String
            let lastName = value["lastName"] as! String
            let gender = value["gender"] as! String
            let bloodType = value["bloodType"] as! String
            let birthday = value["birthday"] as! String
            
            
            self.nameLabel.text = firstName
            self.firstName.text = firstName
            self.lastName.text = lastName
            self.gender.text = gender
            self.dob.text = birthday
            self.bloodType.text = bloodType
            
            
            
        })
    }
    
    
    
    func showPicture() {
        
        let member = FIRDatabase.database().reference().child("members").child(store.familyID).child(store.memberID)
        
        member.observe(.value, with: { snapshot in
            
            var image = snapshot.value as! [String:Any]
            let imageString = image["profileImage"] as! String
            
            let profileImgUrl = URL(string: imageString)
            self.profileImageView.sd_setImage(with: profileImgUrl)
            
            self.profileImageView.setRounded()
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.layer.borderColor = UIColor.gray.cgColor
            self.profileImageView.layer.borderWidth = 0.5
            
        })
    }
}
