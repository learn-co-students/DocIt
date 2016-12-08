//
//  JoinFamily.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class JoinFamily: UIView {

    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    
    // MARK: - Properties
    
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var store = DataStore.sharedInstance
    
    // MARK: - Loads
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.isHidden = true
    }
    
    
    @IBAction func join(_ sender: UIButton) {
        registerAndJoin()
        self.isHidden = true
    }

    // MARK: - Methods
    
    func commonInit() {
        Bundle.main.loadNibNamed("JoinFamily", owner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = Constants.Colors.submarine.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func registerAndJoin() {
        guard let email = nameTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // TODO: Format the error.localizedDescription for natural language, ex. "Invalid email", "Password must be 6 characters or more", etc.
                // Set errorLabel to the error.localizedDescription
//                self.errorLabel.text = error.localizedDescription
                print("===========================\(error.localizedDescription)")
                return
            }
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                
                // Set the sharedInstance familyID to the current user.uid
                self.store.family.id = self.familyTextField.text!
                
                self.database.child("user").child((user?.uid)!).child("FamilyID").setValue(self.store.family.id)
                
                
                
//                self.database.child("family").child((self.store.family.id)).child("email").setValue(email)
                
                // TODO: Set the initial family name to something more descriptive (perhaps using their last name or something?)
//                self.database.child("family").child(self.store.family.id).child("name").setValue("New Family")
                // TO DO: Change segue to notification center post
                
                
//                self.touchID(activate: false)
//                
//                self.saveDataToCoreData()
                
                NotificationCenter.default.post(name: .openfamilyVC, object: nil)
                //  self.performSegue(withIdentifier: "showFamily", sender: nil)
            }
        }

    }
    
}
