//
//  WelcomeViewController.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var signIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        print("createAccountPressed")
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        print("signInPressed")
    }
    
    func setupViews() {
        view.backgroundColor = Constants.Colors.desertStorm
        
        createAccount.layer.cornerRadius = 2
        
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor.lightGray.cgColor
        signIn.layer.cornerRadius = 2
    }

}
