//
//  LoginManager.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 12/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn



class LoginManager: NSObject {
let store = DataStore.sharedInstance
}


// MARK: - Google Sign in
extension LoginManager: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        DispatchQueue.main.async {
            
            guard error == nil else { /* TODO */ return }
            
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                              accessToken: (authentication?.accessToken)!)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in

                DispatchQueue.main.async {
                    NotificationCenter.default.post(name:.closeRegisterVC , object: nil)
                    
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // TODO
    }
    
}
