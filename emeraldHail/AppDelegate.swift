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
        // Override point for customization after application launch.
        
        // MARK: - Branch.io
        
        let branch = Branch.getInstance()
        
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { (params, error) in
            if error == nil {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                print("params: \(params.description)")
            }
        })
        
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        IQKeyboardManager.sharedManager().enable = true
        
        //        if FIRAuth.auth()?.currentUser != nil{
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let controller = storyboard.instantiateViewController(withIdentifier: "FamilyViewController")
        //            window?.rootViewController = controller
        //            window?.makeKeyAndVisible()
        //            //self.presentViewController(controller, animated: true , completion: nil)
        //
        //            //            print("\n\n\nUSER LOGGED IN\n\n\n\n")
        //        }
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    //MARK: Returns the user back to the application after validating gmail. 
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        
        
        guard let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String else {return false}
        
        print("\n\nsource app: \(sourceApplication)\n\n")
        
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || Branch.getInstance().handleDeepLink(url) {
            
            // ^ pass the url to the handle deep link call
        
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
        
        print("\n\nhit didSignInFor in the app delegate\n\n")
        
        if let error = error {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
}



