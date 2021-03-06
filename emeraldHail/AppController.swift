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
    static let openLoginVC = Notification.Name("open-login-view-controller")
    static let openfamilyVC = Notification.Name("open-family-view-controller")
    static let openWelcomeVC = Notification.Name("open-welcome-view-controller")
    static let openRegisterVC = Notification.Name("open-register-view-controller")
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
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .openLoginVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .openfamilyVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .openWelcomeVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(withNotification:)), name: .openRegisterVC, object: nil)
    }
    
}

// MARK: - Loading View Controllers
extension AppController {
    
    // Loads viewControllers based on identifier. need to create id -> pass value to activeVC -> add viewController
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
    
    // Switch the view of the appcontroller based ont he storyboard id
    func switchViewController(withNotification notification: Notification) {
        switch notification.name {
        case Notification.Name.openLoginVC:
            switchToViewController(withStoryboardID: .loginViewController)
        case Notification.Name.openfamilyVC:
            switchToViewController(withStoryboardID: .familyViewController)
        case Notification.Name.openWelcomeVC:
            switchToViewController(withStoryboardID: .welcomeViewController)
        case Notification.Name.openRegisterVC:
            switchToViewController(withStoryboardID: .registerViewController)
        default:
            fatalError("No notifcation exists.")
        }
    }
    
    func switchToViewController(withStoryboardID id: StoryboardID) {
        let existingVC = activeVC
        existingVC?.willMove(toParentViewController: nil)
        
        activeVC = loadViewController(withStoryboardID: id)
        addChildViewController(activeVC)
        add(viewController: activeVC)
        
        activeVC.view.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.activeVC.view.alpha = 1
            existingVC?.view.alpha = 0
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
        
        guard animated else {
            containerView.alpha = 1.0
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView.alpha = 1.0
        })
    }
    
}
