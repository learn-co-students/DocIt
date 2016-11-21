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

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    let family = FIRDatabase.database().reference().child("family")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFamily(_ sender: UIButton) {
        register()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
                        print(error!)
                    }
                }
            }
        }
    }
}
