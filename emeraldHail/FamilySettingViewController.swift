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

class FamilySettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // PROPERTIES

    let store = DataStore.sharedInstance
    let dataStore = DataStore.sharedInstance

    // LOADS

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // ACTIONS

    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            store.clearDataStore()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    @IBAction func changeFamilyNamePressed(_ sender: Any) {
        changeFamilyName()
    }

    @IBAction func changeFamilyPic(_ sender: UIButton) {
        handleSelectProfileImageView()
    }

    // METHODS

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

    @IBAction func activateTouchID(_ sender: UIButton) {
        saveData()
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

    func saveData() {

        let managedContext = dataStore.persistentContainer.viewContext

        let family = CurrentUser(context: managedContext)

        family.familyID = DataStore.sharedInstance.family.id
        
        do {

            try managedContext.save()
            print("I just save the family ID in Core Data")

        } catch {

            print("error")
        }
    }

}
