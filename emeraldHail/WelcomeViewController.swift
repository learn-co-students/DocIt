//
//  WelcomeViewController.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
//import CoreData
//import CoreFoundation
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
    
    //    var userInfo = [CurrentUser]()
    var store = DataStore.sharedInstance
    let database = FIRDatabase.database().reference()
    var context = LAContext()
    let hasLoginKey = UserDefaults.standard.bool(forKey: "hasFamilyKey")
    let MyKeychainWrapper = KeychainWrapper()
    
    
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("welcome - load")
        updateFamilyId()
        print("welcome - updateFamily done")
        setupViews()
        print("welcome - setupView done")
        checkTouchID()
        store.fillWeightData()
        
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
        
        authenticateUser()
        
    }
    
    // MARK: - Methods
    
    func setupViews() {
        
        view.backgroundColor = Constants.Colors.desertStorm
        
        createAccount.docItStyle()
        
        signIn.docItStyle()
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = Constants.Colors.submarine.cgColor
        
        
    }
    
    func updateFamilyId() {
        
        let familyID = UserDefaults.standard.value(forKey: "family") as? String
        
        print("=======================>>>>>>>> THIS IS THE FREAKING FAMILY ID!!!!!!! \(familyID)")
        
        if familyID != nil {
            store.user.familyId = familyID!
            
            
            
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
                    
                    print("WE GOT HERE!!!")
                    
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
    
    
    func navigateToAuthenticatedVC() {
        
        print("welcome - starting authentication")
        
        let email = UserDefaults.standard.value(forKey:"email") as? String
        let userID = UserDefaults.standard.value(forKey: "user") as? String
        let familyID = UserDefaults.standard.value(forKey:"family") as? String
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
            // Set the sharedInstance familyID to the current user.uid
            
            //                self.signinActivityIndicator.startAnimating()
            
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
    
    
    func checkTouchID() {
        
        let touchIDValue = UserDefaults.standard.value(forKey:"touchID") as? String
        
        touchID.isHidden = true
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && touchIDValue == "true" {
            
            touchID.isHidden = false
            authenticateUser()
            
        }
        
    }
    
    
}
