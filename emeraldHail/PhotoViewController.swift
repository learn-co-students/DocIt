//
//  PhotoViewController.swift
//  emeraldHail
//
//  Created by Luna An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import Fusuma

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FusumaDelegate {
    
    var store = DataStore.sharedInstance
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        uploadImageURLtoFirebaseDatabaseAndStorage()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        addGestureRecognizer(imageview: imageView)
        
    }
    
    func addGestureRecognizer(imageview: UIImageView){
        
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraImage)))
        
    }
    
    // Fusuma
    
    func handleCameraImage(){
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion: nil)
        fusumaCropImage = true

    }
    

    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        
        imageView.image = image
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
       print("Camera access denied")
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
