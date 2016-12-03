//
//  WelcomeViewController.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData
import CoreFoundation
import LocalAuthentication

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var touchID: UIButton!
    
    var userInfo = [CurrentUser]()
    var store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        updateFamilyId()
        setupViews()
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        print("createAccountPressed")
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        print("signInPressed")
    }
    
    @IBAction func touchId(_ sender: UIButton) {
        authenticateUser()
    }
    
    
    func setupViews() {
        view.backgroundColor = Constants.Colors.desertStorm
        createAccount.layer.cornerRadius = 2
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor.lightGray.cgColor
        signIn.layer.cornerRadius = 2
    }
    
    func updateFamilyId() {
        
        if !userInfo.isEmpty {
            store.family.id = userInfo[0].familyID!
            touchID.isHidden = false
            print("========= we are in the welcome view and the family id is \(store.family.id)")
        } else {
            touchID.isHidden = true
        }
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                
                if success {
                    self.navigateToAuthenticatedVC()
                    print("yes!")
                } else {
                    if let error = error as? NSError {
                        let message = self.errorMessage(errorCode: error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }
            })
            
        } else {
            self.showAlertViewforNoBiometrics()
            return
        }
    }
    
    func navigateToAuthenticatedVC() {
        self.performSegue(withIdentifier: "showFamily", sender: self)
        //                if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "loggedInVC") {
        //                self.navigationController?.pushViewController(loggedInVC, animated: true)
        //        }
        
        
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
            message = "Authentication was canceled, because the user tapped the fallback button (Enter Password)."
            
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
    
    func fetchData() {
        
        let managedContext = store.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        
        do {
            
            self.userInfo = try managedContext.fetch(fetchRequest)
            
        } catch {
            
            print("error")
        }
    }
}
