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
    @IBOutlet weak var bloodType: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    // MARK: Properties
    
    let store = DataStore.sharedInstance
    var selectedGender = "Female"
    
    
    
    
    var bloodTypeSelections : [String] = [BloodType.ABNeg.rawValue, BloodType.ABPos.rawValue, BloodType.ANeg.rawValue, BloodType.APos.rawValue, BloodType.BNeg.rawValue, BloodType.BPos.rawValue, BloodType.ONeg.rawValue, BloodType.OPos.rawValue]
    
    
    var selectedBloodType = BloodType.ABNeg.rawValue
    
    // Member Profile Properties
    //    var firstName: String?
    //    var lastName: String?
    //    var gender: String?
    //    var DOB: String?
    //    var bloodTypeSelected: String?
    //
    
    
    
    var bloodSelection = UIPickerView()
    
    
    // MARK: Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayMemberProfileEdits()
        
        
        bloodType.delegate = self
        dobTextField.delegate = self
        
        // Blood Type Picker View
        bloodSelection.delegate = self
        bloodSelection.dataSource = self
        bloodType.inputView = bloodSelection
        
        
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    
    @IBAction func saveButton(_ sender: Any) {
        
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
            let firstName = firstNameTextField.text, firstName != "",
            let lastName = lastNameTextField.text, lastName != "",
            let dob = dobTextField.text, dob != "",
            let bloodType = bloodType.text
            else { return }
        
        let updatedInfo: [String:Any] = ["firstName":firstName,
                                         "lastName": lastName,
                                         "birthday": dob,
                                         "gender": selectedGender,
                                         "bloodType": bloodType]
        
        
        //        let gender = selectedGender
        let memberReference : FIRDatabaseReference = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.memberID)
        memberReference.updateChildValues(updatedInfo)
        
        
        self.dismiss(animated: true, completion: nil)
        
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
        return bloodTypeSelections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        bloodType.text = bloodTypeSelections[row]
        self.view.endEditing(true)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypeSelections[row]
    }
    
    func displayMemberProfileEdits() {
        let member = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.memberID)
        
        member.observe(.value, with: { (snapshot) in
            //  print(snapshot.value)
            
            let value = snapshot.value as! [String : Any]
            let imageString = value["profileImage"] as! String
            let profileImgUrl = URL(string: imageString)
            let firstName = value["firstName"] as! String
            let lastName = value["lastName"] as! String
            let gender = value["gender"] as! String
            let bloodType = value["bloodType"] as! String
            let birthday = value["birthday"] as! String
            
            self.nameLabel.text = firstName
            self.firstNameTextField.text = firstName
            self.lastNameTextField.text = lastName
            self.dobTextField.text = birthday
            self.bloodType.text = bloodType
            self.profilePicture.sd_setImage(with: profileImgUrl)
            self.profilePicture.setRounded()
            self.profilePicture.contentMode = .scaleAspectFill
            
            
        })
    }
    
    
    
    //    func showPicture() {
    //
    //        let member = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.memberID)
    //
    //        member.observe(.value, with: { snapshot in
    //
    //            var image = snapshot.value as! [String:Any]
    //            let imageString = image["profileImage"] as! String
    //
    //            let profileImgUrl = URL(string: imageString)
    //            self.profileImageView.sd_setImage(with: profileImgUrl)
    //
    //            self.profileImageView.setRounded()
    //            self.profileImageView.contentMode = .scaleAspectFill
    //            self.profileImageView.layer.borderColor = UIColor.gray.cgColor
    //            self.profileImageView.layer.borderWidth = 0.5
    //
    //        })
    //    }
    
}
