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

class EditMemberSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    // gender selection
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    //datePickerView
    @IBOutlet weak var dobTextField: UITextField!
    
    // bloodType pickerView
    @IBOutlet weak var bloodType: UITextField!
    
    var bloodTypeSelections : [String] = ["A", "B", "AB", "O"]
    
    
    // Send to Firebase
    
    var database : FIRDatabaseReference = FIRDatabase.database().reference()
    var postRef: FIRDatabaseReference = FIRDatabase.database().reference().child("members")
    let storage: FIRStorage = FIRStorage.storage()
    // Member Profile Properties
    var firstName: String?
    var lastName: String?
    var gender: String?
    var DOB: String?
    var bloodTypeSelected: String?
    
    
    // Pickers
    
    var bloodSelection = UIPickerView()
    var dobSelection = UIDatePicker()
    
    //timezone datepicker
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bloodSelection.delegate = self
        bloodSelection.dataSource = self
        bloodType.inputView = bloodSelection

        // Do any additional setup after loading the view.
    }
    
    @IBAction func genderSegmentButton(_ sender: UISegmentedControl) {
        
        
    }
 
    
    
    
    // returns the number of 'columns' to display.
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return bloodTypeSelections.count
    }
    
    // Saves the pickerView selection for bloodType.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodType.text = bloodTypeSelections[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypeSelections[row]
    }
   
    

}

