//
//  AppDelegate.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import IQKeyboardManagerSwift
import Branch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    let store = DataStore.sharedInstance
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: - Branch.io
        let branch = Branch.getInstance()
        
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { (params, error) in
            if error == nil {
                // Params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                if let inviteFamilyID = params["inviteFamilyID"] as? String {
                    self.store.inviteFamilyID = inviteFamilyID
                }
            }
        })
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = Constants.Colors.scooter
        navBarAppearance.tintColor = .white
        navBarAppearance.layer.borderWidth = 0
        navBarAppearance.layer.borderColor = Constants.Colors.scooter.cgColor
        navBarAppearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.isTranslucent = false
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        return true
    }
    
    //MARK: Returns the user back to the application after validating gmail.
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String else {return false}
        
        // Pass the url to the handle deep link call
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || Branch.getInstance().handleDeepLink(url) {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification launchOptions: [AnyHashable: Any]) -> Void {
        Branch.getInstance().handlePushNotification(launchOptions)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("✌🏼")
    }
    
}
