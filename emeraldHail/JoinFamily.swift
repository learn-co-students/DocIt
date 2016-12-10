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
        joinFamily()
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
    
    func joinFamily() {
        
        guard let familyID = familyTextField.text, familyID != "" else { return }
        
        print(store.user.id)
        print(store.user.familyId)
        
        // Set the sharedInstance familyID to the current user.uid
        self.store.user.familyId = familyID
        
        self.database.child(Constants.DatabaseChildNames.user).child(store.user.id).child("familyID").setValue(store.user.familyId)
        
        NotificationCenter.default.post(name: .openfamilyVC, object: nil)
        
        }
    }





