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
let database = FIRDatabase.database().reference()
    
}

// MARK: - Google Sign in
extension LoginManager: GIDSignInDelegate {
    
    
    
    
    
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
        //let store = DataStore.sharedInstance
        //let family = FIRDatabase.database().reference().child("family")
        FIRAuth.auth()?.signIn(with: credential, completion: { loggedInUser, error in
            
            guard let userID = loggedInUser?.uid else {return}
            
            let membersRef = FIRDatabase.database().reference().child("user").child(userID)
            
            membersRef.observeSingleEvent(of: .value, with: { snapshot in
                
                if let snapshot = snapshot.value as? [String:Any] {
                    
            
                    
                    membersRef.child("familyID").setValue(snapshot["familyID"])
                    
                    
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name.openfamilyVC, object: nil)
                        print("A family id exists already.")
                    }
                    
                } else {
                    
                    guard let firebaseUser = loggedInUser else { return }
                    
                    self.store.user.id = firebaseUser.uid
                    
                    let membersRef = FIRDatabase.database().reference().child("user")
                    
                   self.store.user.familyId = membersRef.child(self.store.user.id).child("familyID").childByAutoId().key
                    
                    membersRef.child("email").setValue(user.profile.email)
                    
                    self.database.child("family").child(self.store.user.familyId).child("name").setValue("New Family", withCompletionBlock: {
                        
                        snapshot in
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name.openfamilyVC, object: nil)
                            print("A family id has been created.")
                        }
                        
                        
                    })
                }}
                
            )}
            
        )}
    
    
}
