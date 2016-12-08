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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    let family = FIRDatabase.database().reference()
    
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
        register()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        // If on the create account screen, if they already have an account...take them to the sign in screen
        
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
        
        emailField.layer.cornerRadius = 2
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordField.layer.cornerRadius = 2
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        
        createAccount.isEnabled = false
        createAccount.backgroundColor = UIColor.lightGray
        createAccount.layer.cornerRadius = 2
    }
    
    func register() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // TODO: Format the error.localizedDescription for natural language, ex. "Invalid email", "Password must be 6 characters or more", etc.
                // Set errorLabel to the error.localizedDescription
                self.errorLabel.text = error.localizedDescription
                print("===========================\(error.localizedDescription)")
                return
            }
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                
                // Set the sharedInstance familyID to the current user.uid
                self.store.family.id = (user?.uid)!
                
                self.family.child("user").child(self.store.family.id).setValue(self.store.family.id)
                
                self.family.child("family").child((self.store.family.id)).child("email").setValue(email)
                
                // TODO: Set the initial family name to something more descriptive (perhaps using their last name or something?)
                self.family.child("family").child(self.store.family.id).child("name").setValue("New Family")
                // TO DO: Change segue to notification center post
                
                
                self.touchID(activate: false)
                
                self.saveDataToCoreData()
                
                NotificationCenter.default.post(name: .openfamilyVC, object: nil)
                //  self.performSegue(withIdentifier: "showFamily", sender: nil)
            }
        }
    }
    
    func touchID(activate: Bool) {
        
        FIRDatabase.database().reference().child("settings").child(store.family.id).child("touchID").setValue(activate)
        
    }
    
    func saveDataToCoreData() {
        
        deleteAllData(entity: "CurrentUser")
        
        let managedContext = store.persistentContainer.viewContext
        
        let familyCoreData = CurrentUser(context: managedContext)
        
        familyCoreData.familyID = DataStore.sharedInstance.family.id
        
        do {
            
            try managedContext.save()
            print("I just save the family ID in Core Data")
            
        } catch {
            
            print("error")
        }
    }
    
    func deleteAllData(entity: String)
    {
        let managedContext = store.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
}
