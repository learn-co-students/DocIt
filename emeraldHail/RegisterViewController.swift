//
//  RegisterViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class RegisterViewController: UIViewController {
    
    // TO DO : Create a function that would prevent users from registering with google twice. if they registered they shouldn't be allowed to create an account
    
    // MARK: - Outlets
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    let database = FIRDatabase.database().reference()
    let MyKeychainWrapper = KeychainWrapper()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountPressed(_ sender: Any) {
        createAccount.isEnabled = false
        register()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        // If on the create account screen, if they already have an account...take them to the sign in screen
        signIn.isEnabled = false
        NotificationCenter.default.post(name: .openLoginVC, object: nil)
        //  self.performSegue(withIdentifier: "showLogin", sender: nil)
        
        
    }
    
    // This function enables/disables the createAccount button when the fields are empty/not empty.
    @IBAction func textDidChange(_ sender: UITextField) {
        if !(emailField.text?.characters.isEmpty)! && !(passwordField.text?.characters.isEmpty)! {
            createAccount.isEnabled = true
            createAccount.backgroundColor = Constants.Colors.scooter
        } else {
            createAccount.isEnabled = false
            createAccount.backgroundColor = UIColor.lightGray
        }
    }
    
    // MARK: - Methods
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func setupViews() {
        // Make the email field become the first repsonder and show keyboard when this vc loads
        emailField.becomeFirstResponder()
        
        // Set error label to "" on viewDidLoad
        // Clear the text fields when logging out and returning to the createAccount screen
        errorLabel.text = nil
        emailField.text = nil
        passwordField.text = nil
        
        emailField.docItStyle()
        
        passwordField.docItStyle()
        
        createAccount.isEnabled = false
        createAccount.backgroundColor = Constants.Colors.submarine
        createAccount.docItStyle()
    }
    
    func register() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // TODO: Format the error.localizedDescription for natural language, ex. "Invalid email", "Password must be 6 characters or more", etc.
                // Set errorLabel to the error.localizedDescription
                self.errorLabel.text = error.localizedDescription
                print("========> \(error.localizedDescription)")
                return
            }
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.store.user.email = email
                
                if self.store.inviteFamilyID == "" {
                    // Set the sharedInstance familyID to the current user.uid
                    
                    print("1")
                    
                    self.store.user.id = (user?.uid)!
                    
                    
                    
                    
                    let familyID = self.database.child(Constants.Database.user).child(self.store.user.id).child("familyID").childByAutoId().key
                    
                    print("=========> \(familyID)")
                    
                    self.store.user.familyId = familyID
                    self.store.family.id = self.store.user.familyId
                    self.addDataToKeychain(userID: self.store.user.id, familyID: self.store.user.familyId, email: self.store.user.email)
                    //                    self.store.inviteFamilyID = ""
                    
                    self.database.child(Constants.Database.user).child(self.store.user.id).child("familyID").setValue(familyID)
                    self.database.child(Constants.Database.user).child(self.store.user.id).child("email").setValue(email)
                    self.database.child(Constants.Database.family).child(self.store.user.familyId).child("name").setValue("New Family")
                    
                    self.touchID(activate: false)
                    //                    self.saveDataToCoreData()
                    
                    
                } else {
                    
                    print("2")
                    
                    self.store.user.id = (user?.uid)!
                    
                    self.addDataToKeychain(userID: self.store.user.id, familyID: self.store.user.familyId, email: self.store.user.email)
                    
                    self.store.user.familyId = self.store.inviteFamilyID
                    
                    self.store.family.id = self.store.user.familyId
                    self.database.child(Constants.Database.user).child(self.store.user.id).child("familyID").setValue(self.store.user.familyId)
                    
                    self.store.inviteFamilyID = ""
                    
                    self.database.child(Constants.Database.user).child((self.store.user.id)).child("email").setValue(email)
                    
                }
                
                NotificationCenter.default.post(name: .openfamilyVC, object: nil)
            }
        }
    }
    
    func touchID(activate: Bool) {
        
        FIRDatabase.database().reference().child(Constants.Database.settings).child(store.user.familyId).child("touchID").setValue(activate)
        
    }
    
    func addDataToKeychain(userID: String, familyID: String, email: String) {
        
        UserDefaults.standard.setValue(userID, forKey: "user")
        UserDefaults.standard.setValue(familyID, forKey: "family")
        UserDefaults.standard.setValue(email, forKey: "email")
        
        
        // 5.
        MyKeychainWrapper.mySetObject(passwordField.text, forKey:kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        UserDefaults.standard.set(true, forKey: "hasFamilyKey")
        UserDefaults.standard.synchronize()
        
    }
    
}
