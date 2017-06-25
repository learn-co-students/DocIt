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
        contentView.setConstraintEqualTo(left: leftAnchor, right: rightAnchor, top: topAnchor, bottom: bottomAnchor)
    }
    
    func joinFamily() {
        guard let familyID = familyTextField.text, familyID != "" else { return }
        // Set the sharedInstance familyID to the current user.uid
        Store.userFamily = familyID
        Database.user.child(Store.userId).child(Path.familyId.rawValue).setValue(Store.userFamily)
        NotificationCenter.default.post(name: .openfamilyVC, object: nil)
    }
    
}
