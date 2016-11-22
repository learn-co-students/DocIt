//
//  AddMembersViewController.swift
//  emeraldHail
//
//  Created by Mirim An on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class AddMembersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Reference to database
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    //Reference to members
    var membersRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Members")
    // Reference to storage
    let storage: FIRStorage = FIRStorage.storage()
    // Reference to storage URL
    let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer(imageView: profileImageView)
        profileImageView.isUserInteractionEnabled = true
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = firstNameField.text, name != "",
            let lastName = lastNameField.text, lastName != "",
            let dob = birthdayField.text, dob != "",
            let gender = genderField.text, gender != ""
            else { return }
        
        let databaseMembersRef = database.child("Members").child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId()
        
        let uniqueID = databaseMembersRef.key
        
        let member = Member(firstName: name, lastName: lastName, gender: gender, birthday: dob, uniqueID: uniqueID)
        
        databaseMembersRef.setValue(member.serialize(), withCompletionBlock: { error, dataRef in
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return true
    }
    
    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func uploadImageToFirebaseStorage(data:Data){
        let storageRef = FIRStorage.storage().reference(withPath: "profileImages/demoPic.png")
        
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/png"
        storageRef.put(data, metadata: uploadMetadata, completion:{ (metadata, error) in
            if error != nil {
                print("Error occured! \(error?.localizedDescription)")
            } else {
                print("Upload complete! Here's some metadata \(metadata)")
                print("Here is the download URL: \(metadata?.downloadURL())")
            }
            
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        let imageData = UIImagePNGRepresentation(selectedImageFromPicker!)
        uploadImageToFirebaseStorage(data: imageData!)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picked canceled")
        dismiss(animated: true, completion: nil)
    }

}