//
//  FamilySettingViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import CoreData
import MessageUI
import Branch
import LocalAuthentication

class FamilySettingViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var inviteFamily: UIButton!
    @IBOutlet weak var changeFamilyPicture: UIButton!
    @IBOutlet weak var changeFamilyName: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var touchIDLabel: UILabel!
    @IBOutlet weak var touchIDCell: UITableViewCell!
    @IBOutlet weak var madeCell: UITableViewCell!
    @IBOutlet weak var metricSystemButton: UIButton!
    @IBOutlet weak var imperialSystemButton: UIButton!
    @IBOutlet weak var metricCell: UITableViewCell!
    @IBOutlet weak var imperialCell: UITableViewCell!
    
    let store = DataStore.sharedInstance
    let database = FIRDatabase.database().reference()
    
    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkTouchID()
        checkTouchIDIphone()
        if let measurementSystem = UserDefaults.standard.value(forKey: "isMetric") as? Bool {
            if measurementSystem == true {
                store.isMetric = true
                metricCell.accessoryType = .checkmark
                imperialCell.accessoryType = .none
            } else {
                store.isMetric = false
                imperialCell.accessoryType = .checkmark
                metricCell.accessoryType = .none
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func changeFamilyPic(_ sender: UIButton) {
        handleSelectProfileImageView()
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        logoutApp()
    }
    
    @IBAction func touchIDSwitch(_ sender: Any) {
        if !touchID.isOn {
            touchID(activate: false)
            UserDefaults.standard.setValue("false", forKey: "touchID")
        } else {
            touchID(activate: true)
            UserDefaults.standard.setValue("true", forKey: "touchID")
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        sendEmail()
    }
    
    @IBAction func didPressInviteParent(_ sender: UIButton) {
        inviteParent()
    }
    
    @IBAction func metricButtonTapped(_ sender: UIButton) {
        if store.isMetric == true {
            metricCell.accessoryType = .checkmark
            imperialCell.accessoryType = .none
        } else {
            store.isMetric = true
            UserDefaults.standard.set(true, forKey: "isMetric")
            imperialCell.accessoryType = .none
            metricCell.accessoryType = .checkmark
            print("metric button tapped")
            print("isMetric value in the store is \(store.isMetric)")
        }
    }
    
    @IBAction func imperialButtonTapped(_ sender: UIButton) {
        if store.isMetric == false {
            metricCell.accessoryType = .none
            imperialCell.accessoryType = .checkmark
        } else {
            store.isMetric = false
            UserDefaults.standard.set(false, forKey: "isMetric")
            metricCell.accessoryType = .none
            imperialCell.accessoryType = .checkmark
            print("imperial button tapped")
            print("isMetric value in the store is \(store.isMetric)")
        }
    }
    
    // MARK: - Methods
    func setupView() {
        inviteFamily.docItStyle()
        changeFamilyPicture.docItStyle()
        changeFamilyName.docItStyle()
        logout.docItStyle()
    }
    
    func inviteParent() {
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "123123123")
        
        branchUniversalObject.addMetadataKey("inviteFamilyID", value: store.user.familyId)
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        // This links to our app in the App Store via a Google short url for tracking. If they already have the app installed, it will open the app instead.
        linkProperties.addControlParam("$ios_url", withValue: "https://goo.gl/6HDsNR")
        
        branchUniversalObject.showShareSheet(with: linkProperties, andShareText: "Please join my family on Doc It!", from: self) { (activityType, completed) in
        }
    }
    
    func logoutApp() {
        do {
            try FIRAuth.auth()?.signOut()
            store.clearDataStore()
            
            NotificationCenter.default.post(name: .openWelcomeVC, object: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func changeFamilyCoverPic(photo: UIImage, handler: @escaping (Bool) -> Void) {
        let familyDatabase = database.child(Constants.Database.family).child(store.user.familyId)
        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        let storeImageRef = storageRef.child(Constants.Storage.familyImages).child(store.user.familyId)
        
        guard let uploadData = UIImageJPEGRepresentation(photo, 0.25) else { return }
        
        storeImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error in changeFamilyCoverPic")
                
                return
            }
            
            guard let familyPicString = metadata?.downloadURL()?.absoluteString else { return }
            
            familyDatabase.updateChildValues(["coverImageStr": familyPicString], withCompletionBlock: { (error, dataRef) in
                DispatchQueue.main.async {
                    handler(true)
                }
            })
        })
    }
    
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        var selectedImageFromPicker: UIImage?
        
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            changeFamilyCoverPic(photo: selectedImage, handler: { success in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["thedocitapp@gmail.com"])
            mail.setSubject("Feedback")
            mail.setMessageBody("", isHTML: true)
            
            mail.navigationBar.tintColor = UIColor.white
            
            present(mail, animated: true)
        } else {
            // TODO: Show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - Touch ID Methods
    func checkTouchID() {
        let touchIDValue = UserDefaults.standard.value(forKey:"touchID") as? String
        
        database.child(Constants.Database.settings).child(store.user.familyId).child("touchID").setValue(touchIDValue)
        
        if touchIDValue == "true" {
            self.touchID.setOn(true, animated: false)
        } else {
            self.touchID.setOn(false, animated: false)
        }
    }
    
    
    func checkTouchIDIphone() {
        let context = LAContext()
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            print("this person has touch id")
        } else {
            // Hide Touch ID if user doesn't have the available hardware
            touchID.isHidden = true
            touchIDLabel.isHidden = true
            touchIDCell.isHidden = true
        }
    }
    
    func touchID(activate: Bool) {
        FIRDatabase.database().reference().child(Constants.Database.settings).child(store.user.familyId).child("touchID").setValue(activate)
    }
    
}
