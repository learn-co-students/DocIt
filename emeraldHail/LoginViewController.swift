//
//  LoginViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import GoogleSignIn


class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signinActivityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        hideKeyboardWhenTappedAround()
        
        configureGoogleButton()
        
        // 1.
        //  let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        // 2.
        //if hasLogin {
        //            loginButton.setTitle("Login", forState: UIControlState.Normal)
        //            loginButton.tag = loginButtonTag
        //            createInfoLabel.hidden = true
        // } else {
        //            loginButton.setTitle("Create", forState: UIControlState.Normal)
        //            loginButton.tag = createLoginButtonTag
        //            createInfoLabel.hidden = false
        //}
        
        // 3.
        // if let storedUsername = UserDefaults.standard.bool(forKey:"username") as? String {
        //emailField.text = storedUsername as String
        //}
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
        
    }
    
    // MARK: - Actions
    
    @IBAction func signIn(_ sender: UIButton) {
        signIn.isEnabled = false
        login()
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        createAccount.isEnabled = false
        NotificationCenter.default.post(name: .openRegisterVC, object: nil)
    }
    
    // This function enables/disables the signIn button when the fields are empty/not empty.
    
    @IBAction func textDidChange(_ sender: UITextField) {
        
        if emailField.text == "" {
            // emailLabel.alpha = 0
            signIn.isEnabled = false
            signIn.backgroundColor = Constants.Colors.submarine
            
        } else {
            
            //UIView.animate(withDuration: 0.30) {
              //  self.emailLabel.alpha = 1;
            //}
            
            signIn.isEnabled = true
            signIn.backgroundColor = Constants.Colors.scooter
        }
        
    }
    
    @IBAction func pressedGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Methods
    
    func setupViews() {
        
        // emailLabel.alpha = 0
        
        emailField.becomeFirstResponder()
        
        errorLabel.text = nil
        emailField.text = nil
        passwordField.text = nil
        
        emailField.docItStyle()
        passwordField.docItStyle()
        
        signIn.isEnabled = false
        signIn.backgroundColor = Constants.Colors.submarine
        signIn.docItStyle()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func login() {
        
        signinActivityIndicator.startAnimating()

        guard let email = emailField.text, let password = passwordField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
    
                // Set errorLabel to the error.localizedDescription
                // Activity indicator stops animating here
                self.errorLabel.text = error.localizedDescription
                print("======>\(error.localizedDescription)")
                return
            }
            // Set the sharedInstance familyID to the current user.uid
            
            if self.store.inviteFamilyID == "" {
                
                self.database.child(Constants.Database.user).child((user?.uid)!).observe(.value, with: { snapshot in
                    
                    DispatchQueue.main.async {
                        
                        var data = snapshot.value as? [String:Any]
                        
                        guard let familyID = data?["familyID"] as? String else { return }
                        
                        print("======> \(familyID)")
                        
                        self.store.user.id = (user?.uid)!
                        self.store.user.familyId = familyID
                        self.store.family.id = familyID
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            
                            NotificationCenter.default.post(name: .openfamilyVC, object: nil)
                            self.signinActivityIndicator.stopAnimating()

                        })
                        
                    }
                })
                
            } else {
                
                self.store.user.id = (user?.uid)!
                self.store.user.familyId = self.store.inviteFamilyID
                self.store.family.id = self.store.user.familyId
                self.database.child(Constants.Database.user).child(self.store.user.id).child("familyID").setValue(self.store.user.familyId)
                
                
                self.store.inviteFamilyID = ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    
                    NotificationCenter.default.post(name: .openfamilyVC, object: nil)

                    self.signinActivityIndicator.stopAnimating()
                })
                
            }
            
        }
        
        
        //            NotificationCenter.default.post(name: .openfamilyVC, object: nil)
        //            self.performSegue(withIdentifier: "showFamily", sender: nil)
        
    }
    
    func checkLogin(username: String, password: String ) -> Bool {
        if passwordField.text == MyKeychainWrapper.myObject(forKey: "v_Data") as? String &&
            emailField.text == UserDefaults.standard.value(forKey: "username") as? String {
            return true
        } else {
            return false
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    
}

// MARK: - Google UI Delegate
extension LoginViewController: GIDSignInUIDelegate {
    
    func configureGoogleButton() {
        let googleSignInButton = GIDSignInButton()
        
        googleSignInButton.colorScheme = .light
        googleSignInButton.style = .wide
        
        self.view.addSubview(googleSignInButton)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSignInButton.topAnchor.constraint(equalTo: signIn.bottomAnchor, constant: 12).isActive = true
        view.layoutIfNeeded()
    }
}

// MARK: - Google Sign in

extension LoginViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        activityIndicatorView.startAnimating()

        if let err = error {
            activityIndicatorView.stopAnimating()
            print("Failed to log into Google: ", err)
            return
        }
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { loggedInUser, error in
            
            guard let userID = loggedInUser?.uid else {return}
            
            self.database.child(Constants.Database.user).child(userID).observe(.value, with: { snapshot in
                
                if let data = snapshot.value as? [String:Any] {

                    
                    guard let familyID = data["familyID"] as? String else { return }
                    
                    print("======> \(familyID)")
                    
                    self.store.user.id = userID
                    self.store.user.familyId = familyID
                    self.store.family.id = familyID
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        NotificationCenter.default.post(name: Notification.Name.openfamilyVC, object: nil)
                    })
                    
                    print(self.store.user.id)
                    print(self.store.user.familyId)
                    

                    self.activityIndicatorView.stopAnimating()

                    print("A family id exists already.")
                    
                    
                } else {
                    
                    
                    self.store.user.id = userID
                    
                    let familyID = self.database.child(Constants.Database.user).child(userID).child("familyID").childByAutoId().key
                    
                    print("THIS IS THE FAMILY ID \(familyID)")
                    
                    self.store.user.familyId = familyID
                    self.store.family.id = familyID
                    
                    self.database.child(Constants.Database.user).child(userID).child("familyID").setValue(familyID)
                    self.database.child(Constants.Database.family).child(familyID).child("name").setValue("New Family")
                    self.database.child(Constants.Database.user).child(self.store.user.id).child("email").setValue((loggedInUser?.email)!)
                    
                    print("YEAHHH")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        
                        NotificationCenter.default.post(name: Notification.Name.openfamilyVC, object: nil)
                        
                         self.activityIndicatorView.stopAnimating()
                    })
                    
                }
            })
        })
    }
}
