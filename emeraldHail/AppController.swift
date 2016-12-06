//
//  AppController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 12/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

// N -> L -> S -> A || Notify -> Load -> Switch -> Add 

extension Notification.Name {
    
    static let closeLoginVC = Notification.Name("close-login-view-controller")
    static let closefamilyVC = Notification.Name("close-family-view-controller")
    static let closeWelcomeVC = Notification.Name("close-welcome-view-controller")
    static let closeRegisterVC = Notification.Name("close-register-view-controller")
}

enum StoryboardID: String {
    
    case loginViewController = "login-view-controller"
    case welcomeViewController = "welcome-view-controller"
    case familyViewController = "family-nav-controller"
    case registerViewController = "register-view-controller"
}

class AppController: UIViewController {

    @IBOutlet var containerView: UIView!
    
    var activeVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        loadInitialViewController()
    }

  


}


// MARK: - Notification Observers
extension AppController {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .closeLoginVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .closefamilyVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .closeWelcomeVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .closeRegisterVC, object: nil)
        
       // NotificationCenter.default.post(name: .closeLoginVC, object: nil)  -> notification of a post.
    }
    
}

// MARK: - Loading View Controllers
extension AppController {
    
    //loads viewControllers based on identifier. need to create id -> pass value to activeVC -> add viewController
    func loadInitialViewController() {
        let id: StoryboardID = .welcomeViewController
        activeVC = loadViewController(withStoryboardID: id)
        add(viewController: activeVC, animated: true)
    }
    
    
    
    func loadViewController(withStoryboardID id: StoryboardID) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id.rawValue)
    }
    
    
}


// MARK: - Switching View Controllers
extension AppController {
    
    // switch the view of the appcontroller based ont he storyboard id
    func switchViewController(withNotification notification: Notification) {
        
        switch notification.name {
            
        case Notification.Name.closeLoginVC:
            switchToViewController(withStoryboardID: .familyViewController)
            
        case Notification.Name.closefamilyVC:
            switchToViewController(withStoryboardID: .welcomeViewController)
            
        case Notification.Name.closeWelcomeVC:
            switchToViewController(withStoryboardID: .familyViewController)
            
        case Notification.Name.closeRegisterVC:
            switchToViewController(withStoryboardID: .familyViewController)
            
        default:
            fatalError("No notifcation exists.")
            
        }
    }
    
    func switchToViewController(withStoryboardID id: StoryboardID) {
        let existingVC = activeVC
        existingVC?.willMove(toParentViewController: nil)
        
        activeVC = loadViewController(withStoryboardID: id)
        
        add(viewController: activeVC)
        
        activeVC.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, animations: {
            
            self.activeVC.view.alpha = 1.0
            existingVC?.view.alpha = 0.0
            
        }, completion: { _ in
            
            existingVC?.view.removeFromSuperview()
            existingVC?.removeFromParentViewController()
            self.activeVC.didMove(toParentViewController: self)
        
        })
    }
    
}


// MARK: - Adding View Controllers
extension AppController {
    // Have to create parent-child relationship to addd the subview
    func add(viewController: UIViewController, animated: Bool = false) {
        addChildViewController(viewController)
        
        containerView.addSubview(viewController.view)
        containerView.alpha = 0.0
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
        
        guard animated else { containerView.alpha = 1.0; return }
        
        UIView.transition(with: containerView, duration: 0.9, options: .transitionCrossDissolve, animations: {
            
            self.containerView.alpha = 1.0
            
        }) { _ in }
    }
    
}
