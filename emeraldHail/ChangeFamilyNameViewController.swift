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
    
    @IBOutlet weak var changeNameTextField: UITextField!
    @IBOutlet weak var changeFamilyView: UIView!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    let database =  FIRDatabase.database().reference()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        changeFamilyView.layer.cornerRadius = 10
        changeFamilyView.layer.borderColor = Constants.Colors.submarine.cgColor
        changeFamilyView.layer.borderWidth = 1
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
    
    // MARK: - Methods
    
    func saveNewFamilyName() {
        
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
