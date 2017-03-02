//
//  ChangeFamilyNameViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class ChangeFamilyNameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var changeNameTextField: UITextField!
    @IBOutlet weak var changeFamilyView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    let store = DataStore.sharedInstance
    let database =  FIRDatabase.database().reference()
    
    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        saveNewFamilyName()
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editingFamilyName(_ sender: UITextField) {
        if changeNameTextField.text?.isEmpty == true {
            saveButton.isEnabled = false
            saveButton.backgroundColor = Constants.Colors.submarine
        } else {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Constants.Colors.scooter
        }
    }
   
    // MARK: - Methods
    func setupViews() {
        view.backgroundColor = Constants.Colors.transBlack
        saveButton.docItStyle()
        cancelButton.docItStyle()
        changeNameTextField.docItStyle()
        changeFamilyView.docItStyleView()
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        
        changeNameTextField.text = store.family.name
        changeNameTextField.becomeFirstResponder()
    }
    
    func saveNewFamilyName() {
        saveButton.isEnabled = false
        
        let ref = database.child(Constants.Database.family).child(self.store.user.familyId)
    
        guard let name = changeNameTextField.text, name != "" else { return }
        
        ref.updateChildValues(["name": name], withCompletionBlock: { (error, dataRef) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    
}
