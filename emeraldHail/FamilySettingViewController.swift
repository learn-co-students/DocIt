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

class FamilySettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var touchID: UISegmentedControl!
    
    // MARK: - Properties

    let store = DataStore.sharedInstance

    // MARK: - Loads

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTouchID()
    }

    // MARK: - Actions

    @IBAction func changeFamilyPic(_ sender: UIButton) {
        handleSelectProfileImageView()
    }
    
    @IBAction func changeFamilyNamePressed(_ sender: Any) {
        changeFamilyName()
    }

    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            store.clearDataStore()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    @IBAction func touchIDOnOff(_ sender: UISegmentedControl) {
        
        if touchID.selectedSegmentIndex == 0 {
            
            touchID(activate: false)
            
        }
        
        else if touchID.selectedSegmentIndex == 1 {
            
            touchID(activate: true)
            
        }
        
    }
    @IBAction func sendEmail(_ sender: UIButton) {
        sendEmail()
    }
    
    // MARK: - Methods

    func changeFamilyName() {
        let alert = UIAlertController(title: nil, message: "Change your family name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let userInput = alert.textFields![0].text
            let ref = FIRDatabase.database().reference().child("family").child(self.store.family.id)

            guard let name = userInput, name != "" else { return }

            ref.updateChildValues(["name": name], withCompletionBlock: { (error, dataRef) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.textFields![0].placeholder = store.family.name
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func changeFamilyCoverPic(photo: UIImage, handler: @escaping (Bool) -> Void) {

        let database = FIRDatabase.database().reference()
        let familyDatabase = database.child("family").child(store.family.id)
        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        let storeImageRef = storageRef.child("familyImages").child(store.family.id)

        if let uploadData = UIImageJPEGRepresentation(photo, 0.25) {

            storeImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Error in changeFamilyCoverPic")

                    return
                }

                if let familyPicString = metadata?.downloadURL()?.absoluteString {

                    familyDatabase.updateChildValues(["coverImageStr": familyPicString], withCompletionBlock: { (error, dataRef) in

                        DispatchQueue.main.async {

                            handler(true)
                        }
                    })
                }
            })
        }
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
        print("picked canceled")
        dismiss(animated: true, completion: nil)
    }
    
    
    func checkTouchID() {
        
        let database = FIRDatabase.database().reference().child("settings").child(store.family.id).child("touchID")
        
        database.observe(.value, with: { (snapshot) in
            
          let value = snapshot.value as? Bool
            
            if value == true {
                
                self.touchID.selectedSegmentIndex = 1
                
            }
            
            else if value == false {
                
                self.touchID.selectedSegmentIndex = 0
            }
            
            
        })
        
    }
    
    func touchID(activate: Bool) {
        
        FIRDatabase.database().reference().child("settings").child(store.family.id).child("touchID").setValue(activate)
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["etorrendell@gmail.com"])
            mail.setSubject("Feedback")
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
