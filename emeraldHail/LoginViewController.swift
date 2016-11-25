//
//  LoginViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }
    
    // TODO: Discuss if we should we be hiding the status bar in the entire app?
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
    
    // MARK: Actions
    @IBAction func signIn(_ sender: UIButton) {
        login()
    }
    
    @IBAction func forgotPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot?", message: "Please enter your login email address.\n\nWe'll send you an email with instructions on how to reset your password.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let userInput = alert.textFields![0].text
            if (userInput!.isEmpty) { return }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.textFields![0].placeholder = "yourname@gmail.com"
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showCreateAccount", sender: nil)
    }
    
    // This function enables/disables the signIn button when the fields are empty/not empty.
    @IBAction func textDidChange(_ sender: UITextField) {
        if !(emailField.text?.characters.isEmpty)! && !(passwordField.text?.characters.isEmpty)! {
            signIn.isEnabled = true
            signIn.backgroundColor = Constants.Colors.scooter
        } else {
            signIn.isEnabled = false
            signIn.backgroundColor = UIColor.lightGray
        }
    }
    
    // MARK: Functions
    func setupViews() {
        // Make the email field become the first repsonder and show keyboard when this vc loads
        emailField.becomeFirstResponder()
        
        // Set error label to "" on viewDidLoad
        // Clear the text fields when logging out and returning to the login screen
        errorLabel.text = nil
        emailField.text = nil
        passwordField.text = nil
        
        emailField.layer.cornerRadius = 2
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordField.layer.cornerRadius = 2
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        
        signIn.isEnabled = false
        signIn.backgroundColor = UIColor.lightGray
        signIn.layer.cornerRadius = 2
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }

    // TODO: Need to prevent users from being able to press the login button multiple times
    func login() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // TODO: Format the error.localizedDescription for natural language, ex. "Invalid email", "Password must be 6 characters or more", etc.
                // Set errorLabel to the error.localizedDescription
                self.errorLabel.text = error.localizedDescription
                print("===========================\(error.localizedDescription)")
                return
            }
            self.performSegue(withIdentifier: "showFamily", sender: nil)
        }
    }
    
}
