//
//  TempViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase



class TempViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Tanira: This data is to be used later with the beta version of the application. Please do not remove commented out section below. Thank you :D
    // 0-2 years old rectal thermometer normal is 97.9-100.4 ->Armpit 94.5-99.1 -> Ear 97.5
    // 3-10 years oral thermometer normal is 95.9-99.5 -> Rectal 97.9-100.4-> Armpit 96.6-98.0 -> Ear 97.0-100.0
    // Over age 11 oral thermometer normal is 97.6-99.6 -> rectal 98.6-100.6 -> Armpit 95.3-98.4 -> Ear 96.6-99.7
    
    // MARK: - Outlets
    
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var temperaturePickerView: UIPickerView!
    @IBOutlet weak var tempSegments: UISegmentedControl!

    
    // MARK: - Methods 
    
    let store = DataStore.sharedInstance
    var availableTemps: [String] = ["96.6", "96.8", "97.0", "97.2", "97.4", "97.6", "97.8", "98.0", "98.2", "98.4", "98.6", "98.8", "99.0", "99.2", "99.4", "99.6", "99.8", "100.0", "100.2", "100.4", "100.6", "100.8", "101.0", "101.2", "101.4", "101.6", "101.8", "102.0", "102.2", "102.4", "102.6", "102.8", "103.0", "103.2", "103.4", "103.6", "103.8", "104.0", "104.2", "104.6", "104.8", "105.0"]
    
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("posts")
    
    // Set default temp
    var selectedTemp = "98.6"
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.temperaturePickerView.delegate = self
        self.temperaturePickerView.dataSource = self
        setupView()
       
    }
    
    // Save button temperature for the event based on these three options to member profile.
    // Have to wait to update Post Types before sending data to Firebase and generating eventID.
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIButton) {
    
        dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func save(_ sender: UIButton) {
        saveTemp()
    }
    
    // MARK: - Methods 
    
    func setupView() {
        
        temperaturePickerView.selectRow(10, inComponent: 0, animated: false)
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        
        noteView.layer.cornerRadius = 10
        noteView.layer.borderColor = Constants.Colors.submarine.cgColor
        noteView.layer.borderWidth = 1
        
        temperaturePickerView.backgroundColor = UIColor.white
        temperaturePickerView.tintColor = Constants.Colors.submarine
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
    }

    func saveTemp() {
        let postsRef = database.child("posts").child(store.eventID).childByAutoId()
        let uniqueID = postsRef.key
        
        var tempType: String
        // created Temp Type and switch instance based on selection.
        switch tempSegments.selectedSegmentIndex {
            
        case 0:
            tempType = "Oral"
        case 1:
            tempType = "Ear"
        case 2:
            tempType = "Armpit"
            
            
        default: tempType = "Ear"
        }
        
        let newTemp = Temp(content: selectedTemp, timestamp: getTimestamp(), uniqueID: uniqueID, tempType: tempType)
        
        postsRef.setValue(newTemp.serialize(), withCompletionBlock: { error, ref in
            self.dismiss(animated: true, completion: nil)
        })
        

    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableTemps.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var temperatures = availableTemps[row].description -> Attempt to change the color of the font in the UI PickerView
        return availableTemps[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //save the value for the pickerview temperature selected.
        selectedTemp = availableTemps[row]
        
        
    }
    
    
}
