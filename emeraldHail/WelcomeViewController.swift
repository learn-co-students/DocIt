//
//  WelcomeViewController.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import LocalAuthentication
import GoogleSignIn
import Firebase
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var googleContainerView: UIImageView!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var touchID: UIButton!
    
    // MARK: - Properties
    
    var store = DataStore.sharedInstance
    let database = FIRDatabase.database().reference()
    var context = LAContext()
    let hasLoginKey = UserDefaults.standard.bool(forKey: "hasFamilyKey")
    let MyKeychainWrapper = KeychainWrapper()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFamilyId()
        setupViews()
        checkTouchID()
        store.fillWeightData()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        createAccount.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name.openRegisterVC, object: nil)
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        signIn.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name.openLoginVC, object: nil)
        
    }
    
    @IBAction func touchId(_ sender: UIButton) {
        
        googleOrNot()
        
    }
    
    // MARK: - Methods
    
    func updateFamilyId() {
        
        let familyID = UserDefaults.standard.value(forKey: "family") as? String
        
        if familyID != nil {
            store.user.familyId = familyID!
            
        }
    }
    
    func setupViews() {
        
        view.backgroundColor = Constants.Colors.desertStorm
        createAccount.docItStyle()
        signIn.docItStyle()
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = Constants.Colors.submarine.cgColor
        
    }
    
    func checkTouchID() {
        
        touchID.isHidden = true
        let touchIDValue = UserDefaults.standard.value(forKey:"touchID") as? String
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && touchIDValue == "true" {
            
            googleOrNot()
            touchID.isHidden = false
            
        }
    }
    
    func googleOrNot() {
        
        let accessKey = UserDefaults.standard.value(forKey:"auth") as? String
        
        if accessKey == "google" {
            
            authenticateUserGoogle()
            
        } else {
            
            authenticateUser()
            
        }
    }
    
    // MARK: Methods Touch ID
    
    func authenticateUser() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Touch the Home button to log on."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                
                if success {
                    
                    self.navigateToAuthenticatedVC()
                    
                } else {
                    if let error = error as? NSError {
                        let message = self.errorMessage(errorCode: error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }
            })
            
        } else {
            showAlertViewforNoBiometrics()
            return
            
        }
    }
    
    func authenticateUserGoogle() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Touch the Home button to log on."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                
                if success {
                    
                    GIDSignIn.sharedInstance().signIn()
                    
                }
                    
                else {
                    if let error = error as? NSError {
                        let message = self.errorMessage(errorCode: error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }
            })
            
        } else {
            showAlertViewforNoBiometrics()
            return
            
        }
    }
    
    func navigateToAuthenticatedVC() {
        
        print("welcome - starting authentication")
        
        let email = UserDefaults.standard.value(forKey:"email") as? String
        let userID = UserDefaults.standard.value(forKey: "user") as? String
        let password = MyKeychainWrapper.myObject(forKey: "v_Data") as? String
        
        self.store.user.email = email!
        self.store.user.id = userID!
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
            
            if let error = error {
                
                // Set errorLabel to the error.localizedDescription
                // Activity indicator stops animating here
                //                self.errorLabel.text = error.localizedDescription
                print("======>\(error.localizedDescription)")
                return
            }
            
            //                self.signinActivityIndicator.startAnimating()
            
            self.database.child(Constants.Database.user).child((user?.uid)!).observe(.value, with: { snapshot in
                
                DispatchQueue.main.async {
                    
                    var data = snapshot.value as? [String:Any]
                    
                    guard let familyID = data?["familyID"] as? String else { return }
                
                    self.store.user.id = (user?.uid)!
                    self.store.user.familyId = familyID
                    self.store.family.id = familyID
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        
                        NotificationCenter.default.post(name: .openfamilyVC, object: nil)
                        //                            self.signinActivityIndicator.stopAnimating()
    
                    })
                }
            })
        }
    }
    
    func showAlertViewforNoBiometrics() {
        
        showAlertViewWithTitle(title: "Error", message: "This device does not have a Touch ID sensor.")
        
    }
    
    func showAlertViewWithTitle(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        ac.addAction(ok)
        
        present(ac, animated: true, completion: nil)
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message: String) {
        
        showAlertViewWithTitle(title: "Error", message: message)
        
    }
    
    func errorMessage(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was canceled by application."
        case LAError.authenticationFailed.rawValue:
            message = "Authentication was not successful, because user failed to provide valid credentials."
        case LAError.userCancel.rawValue:
            message = "Authentication was canceled by user"
        case LAError.userFallback.rawValue:
            message = "Authentication was canceled, because the user tapped the fallback button."
        case LAError.systemCancel.rawValue:
            message = "Authentication was canceled by system."
        case LAError.passcodeNotSet.rawValue:
            message = "Authentication could not start, because passcode is not set on the device."
        case LAError.touchIDNotAvailable.rawValue:
            message = "Authentication could not start, because Touch ID is not available on the device."
        case LAError.touchIDNotEnrolled.rawValue:
            message = "Authentication could not start, because Touch ID has no enrolled fingers."
        default:
            message = "Did not find any error in LAError."
        }
        
        return message
        
    }
}

extension WelcomeViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //            activityIndicatorView.startAnimating()
        //
        //            if let err = error {
        //                activityIndicatorView.stopAnimating()
        //                print("Failed to log into Google: ", err)
        //                return
        //            }
        //
        //            activityIndicatorView.startAnimating()
        //            print("Successfully logged into Google", user)
        //
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
                    
                    //self.activityIndicatorView.stopAnimating()
                    
                }
            })
        })
    }
    
    
    func addDataToKeychain(userID: String, familyID: String, email: String, auth: String) {
        
        let keyAccess = "google"
        
        UserDefaults.standard.setValue(userID, forKey: "user")
        UserDefaults.standard.setValue(familyID, forKey: "family")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(keyAccess, forKey: "auth")
        
        //        MyKeychainWrapper.mySetObject(passwordField.text, forKey:kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        UserDefaults.standard.set(true, forKey: "hasFamilyKey")
        UserDefaults.standard.synchronize()
        
    }
}

extension WelcomeViewController: GIDSignInUIDelegate {
    
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
