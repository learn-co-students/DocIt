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

class EditMemberSettingsViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
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
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayMemberProfileEdits()
        
        bloodSelection.delegate = self
        genderSelection.delegate = self
        
        bloodTextField.inputView = bloodSelection
        genderTextField.inputView = genderSelection

    }
    
    // MARK: - Methods
    
    // Storage
    
    @IBAction func deleteMebmerButtonTapped(_ sender: Any) {
        
        // Alert Controller
         let alertController = UIAlertController(title: "Are you sure you want to delete a member?",  message: "This action cannot be undone.", preferredStyle: .alert)
        
        // Action

        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
            
            // Database
            let database = FIRDatabase.database().reference()
            let memberRef = database.child("members").child(self.store.family.id)
            let eventsRef = database.child("events").child(self.store.member.id)
            let postsRef = database.child("posts")
            
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
                
                // Delete the member 
                
                memberRef.child(self.store.member.id).removeValue()
                
                self.performSegue(withIdentifier: "backToFamilyVCSegue", sender: self)
                
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
        
        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        let storageImageRef = storageRef.child("postsImages").child(uniqueID)
        
        storageImageRef.delete(completion: { error -> Void in
            
            if error != nil {
                print("******* Error occured while deleting imgs from Firebase storage ******** \(uniqueID)")
            } else {
                print("Image removed from Firebase successfully! \(uniqueID)")
            }
            
        })
        
    }
    
    @IBAction func saveMemberSettings(_ sender: Any) {
        updateFirebaseValues()
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }

    // MARK: - Methods


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
            let blood = bloodTextField.text, blood != "",
            let gender = genderTextField.text, gender != "",
            let weight = weightTextField.text, weight != "",
            let height = heightTextField.text, height != "",
            let allergies = allergiesTextField.text, allergies != "" else { return }
        
        // TODO: - Do something here to indicate that you can't proceed if a field is empty.
        
        let updatedInfo: [String:Any] = ["firstName":name,
                                         "lastName": lastName,
                                         "birthday": dob,
                                         "gender": gender,
                                         "bloodType": blood,
                                         "height": height,
                                         "weight": weight,
                                         "allergies": allergies]
        
        let memberReference : FIRDatabaseReference = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.member.id)
        memberReference.updateChildValues(updatedInfo)
        
        let _ = navigationController?.popViewController(animated: true)
        
    }
    
    func displayMemberProfileEdits() {
        let member = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.member.id)
        
        member.observe(.value, with: { (snapshot) in
            //  print(snapshot.value)
            
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
    

    //DatePicker -> DOB Text Field
    
    
    // return NO to disallow editing.

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
        //        var calendar = Calendar(identifier: .gregorian)
        dobTextField.text = formatter.string(from: sender.date)
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch pickerView {
        case bloodSelection:
            return store.bloodTypeSelections.count
        case genderSelection:
            return store.genderSelections.count
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
        default:
            break
        }
        
        return ""
    }
    

}
