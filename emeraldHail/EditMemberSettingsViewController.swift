//
//  EditMemberSettingsViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class EditMemberSettingsViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    let bloodSelection = UIPickerView()
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    let weightSelection = UIPickerView()
    let heightSelection = UIPickerView()
    var feet = String()
    var inches = String()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileSettings()
        displayMemberProfileEdits()
        
        bloodSelection.delegate = self
        genderSelection.delegate = self
        weightSelection.delegate = self
        heightSelection.delegate = self
        
        
        bloodTextField.inputView = bloodSelection
        genderTextField.inputView = genderSelection
        weightTextField.inputView = weightSelection
        heightTextField.inputView = heightSelection
        
    }
    
    // Database and Storage
    
    let database = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
    
    // MARK: - Methods
    
    // Storage
    
    
    
    @IBAction func deleteMemberButtonTapped(_ sender: Any) {
        
        // Alert Controller
        let alertController = UIAlertController(title: "Are you sure you want to delete a member?",  message: "This action cannot be undone.", preferredStyle: .alert)
        
        // Action
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
            
            // Database
            let memberRef = self.database.child(Constants.DatabaseChildNames.members).child(self.store.user.familyId)
            let eventsRef = self.database.child(Constants.DatabaseChildNames.events).child(self.store.member.id)
            let postsRef = self.database.child(Constants.DatabaseChildNames.posts)
            
            var posts = [Post]()
            
            // Remove members and related events
            
            var eventIDs = [String]()
            
            eventsRef.observe(.value, with: { snapshot in
                
                for child in snapshot.children {
                    
                    let event = Event(snapshot: child as! FIRDataSnapshot)
                    
                    let eventID = event.uniqueID
                    
                    eventIDs.append(eventID)
                }
                
                for eventID in eventIDs {
                    
                    print("Event ID is: \(eventID)")
                    
                    self.deleteImagesFromStorage(uniqueID: eventID)
                    
                    postsRef.child(eventID).observeSingleEvent(of: .value, with: { snapshot in
                        
                        let oldPosts = snapshot.value as? [String : Any]
                        
                        if let allKeys = oldPosts?.keys {
                            
                            for key in allKeys {
                                
                                let dictionary = oldPosts?[key] as! [String : Any]
                                
                                let post = Post(dictionary: dictionary)
                                
                                posts.append(post)
                                print("0--------------------\(posts)")
                                
                                print(post.description)
                            }
                        }
                    })
                    
                    for post in posts {
                        
                        switch post {
                        case .photo(_):
                            self.deleteImagesFromStorage(uniqueID: post.description)

                        default:
                            break
                        }
                        
                    }
                    
                    postsRef.child(eventID).removeValue() // All posts under event erased
                    
                }
                
                // Delete events associated with the member
                
                eventsRef.removeValue()
                
                // Delete the member from storage
                
                
                self.deleteProfileImagesFromStorage()
                
                // Delete the member from database
                memberRef.child(self.store.member.id).removeValue()
             
                let _ = self.navigationController?.popToRootViewController(animated: true)

            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func deleteImagesFromStorage(uniqueID: String){
        
        storageRef.child(Constants.StorageChildNames.postsImages).child(uniqueID).delete(completion: { error -> Void in
            
            if error != nil {
                print("******* Error occured while deleting post imgs from Firebase storage ******** \(uniqueID)")
            } else {
                print("Post image removed from Firebase successfully! \(uniqueID)")
            }
            
        })
    }
     func deleteProfileImagesFromStorage(){
        
        storageRef.child(Constants.StorageChildNames.profileImages).child(self.store.member.id).delete { error -> Void in
            
            if error != nil {
                print("******* Error occured while deleting profile imgs from Firebase storage ******** \(self.store.member.id)")
            } else {
                print("profile img removed successfully from the associated member")
            }
        }

    }
    
    @IBAction func saveMemberSettings(_ sender: Any) {
        updateFirebaseValues()
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    
    func addProfileSettings() {
        addGestureRecognizer(imageView: profilePicture)
        profilePicture.isUserInteractionEnabled = true
        profilePicture.setRounded()
        profilePicture.layer.borderColor = UIColor.gray.cgColor
        profilePicture.layer.borderWidth = 0.5
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePicture.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picked canceled")
        dismiss(animated: true, completion: nil)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func updateFirebaseValues(){
        guard let name = firstNameTextField.text, name != "",
            let lastName = lastNameTextField.text, lastName != "",
            let dob = dobTextField.text, dob != "",
            let gender = genderTextField.text, gender != "",
            let height = heightTextField.text,
            let weight = weightTextField.text,
            let blood = bloodTextField.text,
            let allergies = allergiesTextField.text else { return }
        
        // TODO: - Do something here to indicate that you can't proceed if a field is empty.
        
        let updatedInfo: [String:Any] = ["firstName":name,
                                         "lastName": lastName,
                                         "birthday": dob,
                                         "gender": gender,
                                         "bloodType": blood,
                                         "height": height,
                                         "weight": weight,
                                         "allergies": allergies]
        
        let memberReference : FIRDatabaseReference = FIRDatabase.database().reference().child(Constants.DatabaseChildNames.members).child(store.user.familyId).child(store.member.id)
        memberReference.updateChildValues(updatedInfo)
        
        let _ = navigationController?.popViewController(animated: true)
        
    }
    
    func displayMemberProfileEdits() {
        let member = FIRDatabase.database().reference().child(Constants.DatabaseChildNames.members).child(store.user.familyId).child(store.member.id)
        
        member.observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as? [String : Any]
            let imageString = value?["profileImage"] as? String
            guard let imgUrl = imageString else {return}
            let profileImgUrl = URL(string: imgUrl)
            let firstName = value?["firstName"] as? String
            let lastName = value?["lastName"] as? String
            let gender = value?["gender"] as? String
            let bloodType = value?["bloodType"] as? String
            let birthday = value?["birthday"] as? String
            let height = value?["height"] as? String
            let weight = value?["weight"] as? String
            let allergies = value?["allergies"] as? String
            
            self.firstNameTextField.text = firstName
            self.lastNameTextField.text = lastName
            self.genderTextField.text = gender
            self.dobTextField.text = birthday
            self.bloodTextField.text = bloodType
            self.allergiesTextField.text = allergies
            self.heightTextField.text = height
            self.weightTextField.text = weight
            self.profilePicture.sd_setImage(with: profileImgUrl)
            self.profilePicture.setRounded()
            self.profilePicture.contentMode = .scaleAspectFill
            
        })
    }
    
    // MARK: Methods Picker View
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        let dobSelection = UIDatePicker()
        dobTextField.inputView = dobSelection
        dobSelection.datePickerMode = UIDatePickerMode.date
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dobTextField.resignFirstResponder()
        return true
    }
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return self.view.endEditing(true)
        
    }
    
    
    func datePickerChanged(sender: UIDatePicker) {
        //        let myLocale = Locale(identifier: "en_US")
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MM-dd-yyyy"
        //        var calendar = Calendar(identifier: .gregopen orian)
        dobTextField.text = formatter.string(from: sender.date)
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        switch pickerView {
        case bloodSelection:
            return 1
        case genderSelection:
            return 1
        case weightSelection:
            return 1
        case heightSelection:
            return 2
        default:
            return 1
        
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch pickerView {
        case bloodSelection:
            return store.bloodTypeSelections.count
        case genderSelection:
            return store.genderSelections.count
        case weightSelection:
            return store.weightSelections.count
        case heightSelection:
            return store.heightSelections.count
        
        default:
            break
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch pickerView {
        case bloodSelection:
            bloodTextField.text = store.bloodTypeSelections[row]
        case genderSelection:
            genderTextField.text = store.genderSelections[row]
        case weightSelection:
            weightTextField.text = store.weightSelections[row]
        case heightSelection:
            if component == 0 {
                feet = store.heightSelectionsFeet[row]
                print("DID I GET SOME \(feet)")
            } else if component == 1 {
                inches = store.heightSelections[row]
                print("DID I GET ALOT OF \(inches)")
            }
            heightTextField.text = "\(feet)\(inches)"
        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case bloodSelection:
            return store.bloodTypeSelections[row]
        case genderSelection:
            return store.genderSelections[row]
        case weightSelection:
            return store.weightSelections[row]
        case heightSelection:
            if component == 0{
                return store.heightSelectionsFeet[row]
            } else {
                return store.heightSelections[row]
            }
        default:
            break
        }
        
        return ""
    }
    
    
}
