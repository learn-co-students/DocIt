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
import Fusuma

class EditMemberSettingsViewController: UITableViewController, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, FusumaDelegate {
    
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
    @IBOutlet weak var deleteMember: UIButton!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    let store = DataStore.sharedInstance
    let bloodSelection = UIPickerView()
    let database = FIRDatabase.database().reference()
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    let weightSelection = UIPickerView()
    let heightSelection = UIPickerView()
    var feet = String()
    var inches = String()
    var meter = String()
    var centimeter = "0"
    var kg = "0"
    var g = "0"
    
    // MARK: - Loads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let measurementSystem = UserDefaults.standard.value(forKey: "isMetric") as? Bool {
            if measurementSystem == true {
                store.isMetric = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileSettings()
        displayMemberProfileEdits()
        
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func didPressSave(_ sender: Any) {
        save.isEnabled = false
        activityIndicatorView.startAnimating()
        updateFirebaseValues()
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressDeleteMember(_ sender: Any) {
        deleteMember.isEnabled = false
        
        // Alert Controller
        let alertController = UIAlertController(title: "Are you sure you want to delete this member?",  message: "This action cannot be undone.", preferredStyle: .alert)
        
        // Action
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
            
            // Database
            let memberRef = Database.members.child(Store.userFamily)
            let eventsRef = Database.events.child(self.store.member.id)
            let postsRef = Database.posts
            
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
                    self.deletePostImagesFromStorage(uniqueID: eventID)
                    
                    postsRef.child(eventID).observeSingleEvent(of: .value, with: { snapshot in
                        let oldPosts = snapshot.value as? [String : Any]
                        guard let allKeys = oldPosts?.keys else { return }
                        
                        for key in allKeys {
                            let dictionary = oldPosts?[key] as! [String : Any]
                            let post = Post(dictionary: dictionary)
                            
                            posts.append(post)
                        }
                    })
                    
                    for post in posts {
                        switch post {
                        case .photo(_):
                            self.deletePostImagesFromStorage(uniqueID: post.description)
                        default:
                            break
                        }
                    }
                    
                    postsRef.child(eventID).removeValue()
                    // All posts under event erased
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
    
    // MARK: - Methods
    @IBAction func genderEditingDidBegin(_ sender: Any) {
        genderTextField.text = store.genderSelections[genderSelection.selectedRow(inComponent: 0)]
    }
    
    @IBAction func heightEditingDidBegin(_ sender: Any) {
        if store.isMetric == false {
            heightTextField.text = store.heightsInInches[heightSelection.selectedRow(inComponent: 0)] + store.heightsInFeet[heightSelection.selectedRow(inComponent: 1)]
        } else {
            heightTextField.text = store.heightsInMeter[heightSelection.selectedRow(inComponent: 0)] + store.heightsInCm[heightSelection.selectedRow(inComponent: 1)]
        }
    }
    @IBAction func weightEditingDidBegin(_ sender: Any) {
        weightTextField.text = store.weightsInLbs[weightSelection.selectedRow(inComponent: 0)]
    }
    
    @IBAction func bloodTypeEditingDidBegin(_ sender: Any) {
        bloodTextField.text = store.bloodTypeSelections[bloodSelection.selectedRow(inComponent: 0)]
    }
    
    @IBAction func birthdayEditingDidBegin(_ sender: Any) {
        let dobSelection = UIDatePicker()
        dobTextField.inputView = dobSelection
        dobSelection.datePickerMode = UIDatePickerMode.date
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    @IBAction func didPressChangePhoto(_ sender: Any) {
        handleCameraImage()
    }
    
    func setupViews() {
        bloodSelection.delegate = self
        genderSelection.delegate = self
        weightSelection.delegate = self
        heightSelection.delegate = self
        
        bloodTextField.inputView = bloodSelection
        genderTextField.inputView = genderSelection
        weightTextField.inputView = weightSelection
        heightTextField.inputView = heightSelection
    }
    
    // MARK: - Firebase Storage Image Deletion
    func deletePostImagesFromStorage(uniqueID: String) {
        Database.storagePosts.child(uniqueID).delete { error -> Void in
            if error != nil {
                print("******* Error occured while deleting post imgs from Firebase storage ******** \(uniqueID)")
            } else {
                print("Post image removed from Firebase successfully! \(uniqueID)")
            }
        }
    }
    
    func deleteProfileImagesFromStorage() {
        Database.storageProfile.child(self.store.member.id).delete { error -> Void in
            if error != nil {
                print("******* Error occured while deleting profile imgs from Firebase storage ******** \(self.store.member.id)")
            } else {
                print("profile img removed successfully from the associated member")
            }
        }
    }
    
    // MARK: - Methods
    func addProfileSettings() {
        addGestureRecognizer(imageView: profilePicture)
        profilePicture.isUserInteractionEnabled = true
        profilePicture.setRounded()
    }
    
    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraImage)))
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func updateFirebaseValues() {
        guard let name = firstNameTextField.text, name != "",
            let lastName = lastNameTextField.text, lastName != "",
            let dob = dobTextField.text, dob != "",
            let gender = genderTextField.text, gender != "",
            let height = heightTextField.text,
            let weight = weightTextField.text,
            let blood = bloodTextField.text,
            let profilePicture = profilePicture.image,
            let allergies = allergiesTextField.text else { return }
        
        let memberReference = Database.members.child(Store.userFamily).child(store.member.id)
        let databaseMembersRef = Database.members.child(Store.userFamily).childByAutoId()
        let uniqueID = databaseMembersRef.key
        let imageId = uniqueID
        let storageImageRef = Database.storageProfile.child(imageId)
        
        if let uploadData = UIImageJPEGRepresentation(profilePicture, 0.25) {
            storageImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print (error?.localizedDescription ?? "Error in saveButtonTapped in EditMembersViewController.swift" )
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                let updatedInfo: [String : Any] = ["firstName":name,
                                                   "lastName": lastName,
                                                   "birthday": dob,
                                                   "gender": gender,
                                                   "profileImage": profileImageUrl,
                                                   "bloodType": blood,
                                                   "height": height,
                                                   "weight": weight,
                                                   "allergies": allergies]
                
                memberReference.updateChildValues(updatedInfo)
                
                let _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func displayMemberProfileEdits() {
        let member = Database.members.child(Store.userFamily).child(store.member.id)
        member.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String : Any]
            let imageString = value?["profileImage"] as? String
            guard let imgUrl = imageString else { return }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dobSelection = UIDatePicker()
        dobTextField.inputView = dobSelection
        dobSelection.datePickerMode = UIDatePickerMode.date
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dobTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.view.endEditing(true)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        
        dobTextField.text = formatter.string(from: sender.date).uppercased()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        if store.isMetric == false {
            switch pickerView {
            case bloodSelection, genderSelection, weightSelection:
                return 1
            case heightSelection:
                return 2
            default:
                return 1
            }
        } else {
            switch pickerView {
            case bloodSelection, genderSelection:
                return 1
            case weightSelection, heightSelection:
                return 2
            default:
                return 1
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if store.isMetric == false {
            switch pickerView {
            case bloodSelection:
                return store.bloodTypeSelections.count
            case genderSelection:
                return store.genderSelections.count
            case weightSelection:
                return store.weightsInLbs.count
            case heightSelection:
                if component == 0 {
                    return store.heightsInFeet.count
                } else if component == 1 {
                    return store.heightsInInches.count
                }
            default:
                break
            }
            return 0
        } else {
            switch pickerView {
            case bloodSelection:
                return store.bloodTypeSelections.count
            case genderSelection:
                return store.genderSelections.count
            case weightSelection:
                if component == 0 {
                    return store.weightsInKg.count
                } else if component == 1 {
                    return store.weightsInG.count
                }
            case heightSelection:
                if component == 0 {
                    return store.heightsInMeter.count
                } else if component == 1 {
                    return store.heightsInCm.count
                }
            default:
                break
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if store.isMetric == false {
            switch pickerView {
            case bloodSelection:
                bloodTextField.text = store.bloodTypeSelections[row]
            case genderSelection:
                genderTextField.text = store.genderSelections[row]
            case weightSelection:
                weightTextField.text = store.weightsInLbs[row]
            case heightSelection:
                if component == 0 {
                    feet = store.heightsInFeet[row]
                } else if component == 1 {
                    inches = store.heightsInInches[row]
                }
                heightTextField.text = "\(feet)\(inches)"
            default:
                break
            }
        } else {
            switch pickerView {
            case bloodSelection:
                bloodTextField.text = store.bloodTypeSelections[row]
            case genderSelection:
                genderTextField.text = store.genderSelections[row]
            case weightSelection:
                if component == 0 {
                    kg = store.weightsInKg[row]
                } else if component == 1 {
                    g = store.weightsInG[row]
                }
                
                weightTextField.text = "\(kg).\(g) kg"
                
            case heightSelection:
                if component == 0 {
                    meter = store.heightsInMeter[row]
                } else if component == 1 {
                    centimeter = store.heightsInCm[row]
                }
                if meter == " - " {
                    heightTextField.text = "\(centimeter)"
                } else {
                    heightTextField.text = "\(meter) \(centimeter)"
                }
            default:
                break
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var width = CGFloat(100.0)
        if store.isMetric == true {
            switch pickerView {
            case weightSelection:
                width = 65.0
            default:
                width = 100.0
            }
        }
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if store.isMetric == false {
            switch pickerView {
            case bloodSelection:
                return store.bloodTypeSelections[row]
            case genderSelection:
                return store.genderSelections[row]
            case weightSelection:
                return store.weightsInLbs[row]
            case heightSelection:
                if component == 0 {
                    return store.heightsInFeet[row]
                } else if component == 1 {
                    return store.heightsInInches[row]
                }
            default:
                break
            }
            return ""
        } else {
            switch pickerView {
            case bloodSelection:
                return store.bloodTypeSelections[row]
            case genderSelection:
                return store.genderSelections[row]
            case weightSelection:
                if component == 0 {
                    return "\(store.weightsInKg[row]) ."
                } else if component == 1 {
                    return "\(store.weightsInG[row]) kg"
                }
            case heightSelection:
                if component == 0 {
                    return store.heightsInMeter[row]
                } else if component == 1 {
                    return store.heightsInCm[row]
                }
            default:
                break
            }
            return ""
        }
    }
    
    // MARK: Fusuma
    func handleCameraImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion: nil)
        fusumaCropImage = true
    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        
        // present some alert with the image
        // add button to alert to send
        // upload from button
        
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        profilePicture.image = image
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        // TODO: Handle what happens when the camera is not authorized
        print("Camera access denied")
    }
    
}
