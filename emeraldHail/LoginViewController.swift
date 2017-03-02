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
            signIn.isEnabled = false
            signIn.backgroundColor = Constants.Colors.submarine
        } else {
            signIn.isEnabled = true
            signIn.backgroundColor = Constants.Colors.scooter
        }
    }
    
    @IBAction func pressedGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Methods
    func setupViews() {
        hideKeyboardWhenTappedAround()
        configureGoogleButton()
        
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
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.errorLabel.text = error.localizedDescription
                return
            }
            
            // Set the sharedInstance familyID to the current user.uid
            if self.store.inviteFamilyID == "" {
                self.signinActivityIndicator.startAnimating()
                self.database.child(Constants.Database.user).child((user?.uid)!).observe(.value, with: { snapshot in
                    DispatchQueue.main.async {
                        var data = snapshot.value as? [String:Any]
                        guard let familyID = data?["familyID"] as? String else { return }
                        
                        self.store.user.id = (user?.uid)!
                        self.store.user.familyId = familyID
                        self.store.family.id = familyID
                        self.store.user.email = email
                        self.addDataToKeychain(userID: self.store.user.id, familyID: self.store.user.familyId, email: self.store.user.email, auth: "email")
                        
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
                self.store.user.email = email
                self.database.child(Constants.Database.user).child(self.store.user.id).child("familyID").setValue(self.store.user.familyId)
                self.store.inviteFamilyID = ""
                self.addDataToKeychain(userID: self.store.user.id, familyID: self.store.user.familyId, email: self.store.user.email, auth: "email")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    NotificationCenter.default.post(name: .openfamilyVC, object: nil)
                    self.signinActivityIndicator.stopAnimating()
                })
            }
        }
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

// MARK: - Google Sign In
extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        activityIndicatorView.startAnimating()
        // TODO: Handle error
        if let err = error {
            activityIndicatorView.stopAnimating()
            print("Failed to log into Google: ", err)
            return
        }
        
        activityIndicatorView.startAnimating()
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { loggedInUser, error in
            guard let userID = loggedInUser?.uid else {return}
            guard let email = loggedInUser?.email else { return }
            
            self.store.user.email = email
            self.database.child(Constants.Database.user).child(userID).observe(.value, with: { snapshot in
                
                if let data = snapshot.value as? [String:Any] {
                    guard let familyID = data["familyID"] as? String else { return }
                    
                    self.store.user.id = userID
                    self.store.user.familyId = familyID
                    self.store.family.id = familyID
                    self.addDataToKeychain(userID: self.store.user.id, familyID: self.store.user.familyId, email: self.store.user.email, auth: "google")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        NotificationCenter.default.post(name: Notification.Name.openfamilyVC, object: nil)
                    })
                } else {
                    let familyID = self.database.child(Constants.Database.user).child(userID).child("familyID").childByAutoId().key
                    
                    self.store.user.id = userID
                    self.store.user.familyId = familyID
                    self.store.family.id = familyID
                    self.addDataToKeychain(userID: self.store.user.id, familyID: self.store.user.familyId, email: self.store.user.email, auth: "google")
                    self.database.child(Constants.Database.user).child(userID).child("familyID").setValue(familyID)
                    self.database.child(Constants.Database.family).child(familyID).child("name").setValue("New Family")
                    self.database.child(Constants.Database.user).child(self.store.user.id).child("email").setValue((loggedInUser?.email)!)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        NotificationCenter.default.post(name: Notification.Name.openfamilyVC, object: nil)
                    })
                }
            })
        })
    }
    
    func addDataToKeychain(userID: String, familyID: String, email: String, auth: String) {
        UserDefaults.standard.setValue(userID, forKey: "user")
        UserDefaults.standard.setValue(familyID, forKey: "family")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(auth, forKey: "auth")
        
        MyKeychainWrapper.mySetObject(passwordField.text, forKey:kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        UserDefaults.standard.set(true, forKey: "hasFamilyKey")
        UserDefaults.standard.synchronize()
    }
    
}
