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



class LoginManager: NSObject { }


// MARK: - Google Sign in
extension LoginManager: GIDSignInDelegate {
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        DispatchQueue.main.async {
//            
//            guard error == nil else { /* TODO */ return }
//            
//            let authentication = user.authentication
//            let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
//                                                              accessToken: (authentication?.accessToken)!)
//            
//            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
//
//                DispatchQueue.main.async {
//                    NotificationCenter.default.post(name:.closeRegisterVC , object: nil)
//                    
//                }
//            }
//        }
//    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // TODO
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(123123123123)
        
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { loggedInUser, error in
            DispatchQueue.main.async {
                guard let firebaseUser = loggedInUser else { return }
                DataStore.sharedInstance.family.id = firebaseUser.uid
                let membersRef = FIRDatabase.database().reference().child("family")
                let newFamilyRef = membersRef.child(firebaseUser.uid)
                
                newFamilyRef.setValue(["email": user.profile.email])
                newFamilyRef.setValue(["name" : "New Family"], withCompletionBlock: { error, ref in
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name.closeWelcomeVC, object: nil)
                        print("A family id has been created.")

                    }
                    
                    
                })

                
            }
            
            
        })
        
    }
    
}
