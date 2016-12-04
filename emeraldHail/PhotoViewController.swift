//
//  PhotoViewController.swift
//  emeraldHail
//
//  Created by Luna An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import ALCameraViewController

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var store = DataStore.sharedInstance
    var selectedImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        uploadImageURLtoFirebaseDatabaseAndStorage()
    }
    
    @IBOutlet weak var selectFromLibraryButton: UIButton!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        selectFromLibraryButton.isUserInteractionEnabled = true
        addGestureRecognizer(imageview: imageView, button: selectFromLibraryButton)
        
    }
    
    
    func addGestureRecognizer(imageview: UIImageView, button: UIButton){
        
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraImage)))
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLibraryImage)))
    }
    
    func handleCameraImage(){
        
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            print("The device has no camera")
        }
        
        picker.allowsEditing = true
        
    }
    
    func handleLibraryImage(){
        
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            
        } else {
            print("No photo library")
        }
        
        picker.allowsEditing = true
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageURLtoFirebaseDatabaseAndStorage(){
        
        uploadImageButton?.isEnabled = false
        
        guard let image = imageView.image, image != UIImage(named: "addImageIcon") else { return }
        
        // database
        
        let database: FIRDatabaseReference = FIRDatabase.database().reference()
        
        let databasePostsRef = database.child("posts").child(store.eventID).childByAutoId()
        
        let uniqueID = databasePostsRef.key
        
        // storage
        
        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        
        store.imagePostID = uniqueID
        
        let storageImageRef = storageRef.child("postsImages").child(store.imagePostID)
        
        if let uploadData = UIImageJPEGRepresentation(self.imageView.image!, 1.0){
            
            storageImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print (error?.localizedDescription ?? "Error in PhotoVC" )
                    return
                }
                
                if let postImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    //let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss a"
                    //let timestamp = dateFormatter.string(from: currentDate)
                    
                    let photo = Photo(content: postImageUrl, timestamp: self.getTimestamp(), uniqueID: uniqueID)
                    
                    databasePostsRef.setValue(photo.serialize(), withCompletionBlock: { error, dataRef in
                        // Disable the save button after it's pressed once
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                }
                
            })
        }
        
        
    }
    
}
