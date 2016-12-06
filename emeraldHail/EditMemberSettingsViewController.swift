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

class EditMemberSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    
    // MARK: Properties
    
    let store = DataStore.sharedInstance
    
    let bloodSelection = UIPickerView()
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    
    
    // MARK: Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayMemberProfileEdits()
        
        bloodSelection.delegate = self
        genderSelection.delegate = self

        bloodTextField.inputView = bloodSelection
        genderTextField.inputView = genderSelection

    }
    
    // MARK: Actions
    
    @IBAction func deleteMebmerButtonTapped(_ sender: Any) {
        
        // Alert Controller
         let alertController = UIAlertController(title: "Are you sure you want to delete a member?",  message: "This action cannot be undone.", preferredStyle: .alert)
        
        // Action
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
            
            let database = FIRDatabase.database().reference()
            let memberRef = database.child("members").child(self.store.family.id)
            let eventsRef = database.child("events").child(self.store.member.id)
            let postsRef = database.child("posts")
            
            // Remove related events, members and posts from database

            eventsRef.removeValue()
            memberRef.child(self.store.member.id).removeValue()
            
            self.performSegue(withIdentifier: "backToFamilyVCSegue", sender: self)
            
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
        

        // Remove images associated with the member from stroage
        
        
        
    }

    
    
    @IBAction func saveMember(_ sender: UIButton) {
        updateFirebaseValues()
    }
  
    
    // MARK: Methods
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    
    
    //Firebase Update Value
    // this function needs to dismiss the datePicker as well as handling one property member profile change doesn't reset everything.
    func updateFirebaseValues(){
        guard let name = firstNameTextField.text, name != "",
            let lastName = lastNameTextField.text, lastName != "",
            let dob = dobTextField.text, dob != "", let blood = bloodTextField.text, blood != "", let gender = genderTextField.text, gender != "", let weight = weightTextField.text, weight != "", let height = heightTextField.text, height != "", let allergies = allergiesTextField.text, allergies != "" else { return }
        
        let updatedInfo: [String:Any] = ["firstName":name,
                                         "lastName": lastName,
                                         "birthday": dob,
                                         "gender": gender,
                                         "bloodType": blood,
                                         "height": height,
                                         "weight": weight,
                                         "allergies": allergies]
        
        
        //        let gender = selectedGender
        let memberReference : FIRDatabaseReference = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.member.id)
        memberReference.updateChildValues(updatedInfo)
        
        
    }
    
    
    //DatePicker -> DOB Text Field
    
    
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        return true
    }
    
    // became first responder
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
    
    // PickerView methods for Blood Type
    
    
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
        
        self.view.endEditing(true)
        
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
    
    func displayMemberProfileEdits() {
        let member = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.member.id)
        
        member.observe(.value, with: { (snapshot) in
            //  print(snapshot.value)
            
            let value = snapshot.value as? [String : Any]
            let imageString = value?["profileImage"] as? String
            
            guard let imgUrl = imageString else{ return }
            let profileImgUrl = URL(string: imgUrl)
            
            let firstName = value?["firstName"] as! String
            let lastName = value?["lastName"] as! String
            let gender = value?["gender"] as! String
            let bloodType = value?["bloodType"] as! String
            let birthday = value?["birthday"] as! String
            let height = value?["height"] as! String
            let weight = value?["weight"] as! String
            let allergies = value?["allergies"] as! String
            
            self.nameLabel.text = firstName
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
}
