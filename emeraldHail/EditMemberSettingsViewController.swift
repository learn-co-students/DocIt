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

    let store = Logics.sharedInstance
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var selectedGender = "Female"
    
    // gender selection 
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    //datePickerView
    @IBOutlet weak var dobTextField: UITextField!
    
    // bloodType pickerView
    @IBOutlet weak var bloodType: UITextField!
    
    var bloodTypeSelections : [String] = ["A", "B", "AB", "O"]
    
    

    
    // Member Profile Properties
//    var firstName: String?
//    var lastName: String?
//    var gender: String?
//    var DOB: String?
//    var bloodTypeSelected: String?
//    
    

    
    var bloodSelection = UIPickerView()
    
    
    //timezone datepicker
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextField Delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        dobTextField.delegate = self
        bloodType.delegate = self
        
        
        
        // Blood Type Picker View
        bloodSelection.delegate = self
        bloodSelection.dataSource = self
        bloodType.inputView = bloodSelection
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func genderSegmentButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedGender = Gender.female.rawValue
            Logics.sharedInstance.genderType = selectedGender
        case 1:
            selectedGender = Gender.male.rawValue
            Logics.sharedInstance.genderType = selectedGender
        default:
            break
        }
        
        
    }
    //             let bloodType = bloodType.text, bloodType != "" --> add value for new property 
    //

    
    @IBAction func saveButton(_ sender: Any) {
        // Send to Firebase
        updateFirebaseValues()
      
        
        
        
    }
    

    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Firebase Update Value
    
    func updateFirebaseValues(){
        guard let name = firstNameTextField.text, name != "",
            let firstName = firstNameTextField.text, firstName != "",
            let lastName = lastNameTextField.text, lastName != "",
            let dob = dobTextField.text, dob != ""
            else { return }
        
        let updatedInfo: [String:Any] = ["firstName":firstName,
                                         "lastName": lastName,
                                         "birthday": dob,
                                         "gender": selectedGender]
        
        
        let gender = selectedGender
        var memberReference : FIRDatabaseReference = FIRDatabase.database().reference().child("members").child(Logics.sharedInstance.familyID).child(Logics.sharedInstance.memberID)
        memberReference.updateChildValues(updatedInfo)
        
        var databaseReference: FIRDatabaseReference = FIRDatabase.database().reference().child("members").child(Logics.sharedInstance.familyID).child(Logics.sharedInstance.memberID)
        
     //   let member = Member(profileImage: <#T##String#>, firstName: <#T##String#>, lastName: <#T##String#>, gender: <#T##String#>, birthday: <#T##String#>, uniqueID: <#T##String#>)
        
       // databaseReference.setValue(member.serialize(), withCompletionBlock: {error, FIRDatabaseReference in
            self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
 
    //MARK: DatePicker -> DOB Text Field
    
    
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
        return true
    }
    
    
    func datePickerChanged(sender: UIDatePicker) {
         let myLocale = Locale(identifier: "en_US")
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MM-dd-yyyy"
        var calendar = Calendar(identifier: .gregorian)
        dobTextField.text = formatter.string(from: sender.date)
        
        
    }
    
    // MARK: PickerView methods for Blood Type
    

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
   
    

}

