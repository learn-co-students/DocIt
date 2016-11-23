//
//  RegisterViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    // outlets
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    // properties
    
    let family = FIRDatabase.database().reference().child("family")
    
    // loads 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    // actions
    
    @IBAction func addFamily(_ sender: UIButton) {
        register()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // methods
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }

    func register() {
        
        guard let email = textEmail.text else { return }
        guard let password = textPassword.text else { return }
        
        if email != "" && password != "" {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    self.family.child((user?.uid)!).child("email").setValue(email)
                    self.family.child((user?.uid)!).child("name").setValue("new family")
                    
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
}
