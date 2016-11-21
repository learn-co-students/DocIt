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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // actions
    @IBAction func signIn(_ sender: UIButton) {
        print("didTapSignIn")
        login()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        print("didTapCreateAccount")
        performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    @IBAction func forgot(_ sender: UIButton) {
        performSegue(withIdentifier: "showForgot", sender: self)
    }

    // functions
    func setupViews() {
        signIn.layer.cornerRadius = 2
        createAccount.layer.borderWidth = 1
        createAccount.layer.borderColor = UIColor.lightGray.cgColor
        createAccount.layer.cornerRadius = 2
    }
    
    func login() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "showFamily", sender: nil)
        }
    }
    
}

class ForgotViewController: UIViewController {
    
    @IBOutlet weak var textEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPassword(_ sender: UIButton) {
        print("send email")
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
