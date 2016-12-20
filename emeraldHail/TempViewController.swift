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

    let store = DataStore.sharedInstance

    // Tanira: This data is to be used later with the beta version of the application. Please do not remove commented out section below. Thank you :D
    // 0-2 years old rectal thermometer normal is 97.9-100.4 ->Armpit 94.5-99.1 -> Ear 97.5
    // 3-10 years oral thermometer normal is 95.9-99.5 -> Rectal 97.9-100.4-> Armpit 96.6-98.0 -> Ear 97.0-100.0
    // Over age 11 oral thermometer normal is 97.6-99.6 -> rectal 98.6-100.6 -> Armpit 95.3-98.4 -> Ear 96.6-99.7

    // MARK: - Outlets

    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var temperaturePickerView: UIPickerView!
    @IBOutlet weak var tempSegments: UISegmentedControl!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!


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

    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: - Methods

    func setupView() {

        postTitleLabel.text = "What's \(store.member.firstName)'s Temp?"

        temperaturePickerView.selectRow(10, inComponent: 0, animated: false)

        view.backgroundColor = Constants.Colors.transBlack

        noteView.docItStyleView()

        tempSegments.layer.cornerRadius = 2

        temperaturePickerView.backgroundColor = UIColor.white
        temperaturePickerView.tintColor = Constants.Colors.submarine

        saveButton.docItStyle()

//        saveButton.isEnabled = false
//        saveButton.backgroundColor = Constants.Colors.submarine
        cancelButton.docItStyle()
        
    }

    func saveTemp() {
        saveButton.isEnabled = false
        let postsRef = database.child(Constants.Database.posts).child(store.eventID).childByAutoId()
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
        var numberOfItems = 0
        if store.isMetric == false {
            numberOfItems = store.tempsInF.count
        } else {
            numberOfItems = store.tempsInC.count
        }
        return numberOfItems
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var temperatures = availableTemps[row].description -> Attempt to change the color of the font in the UI PickerView
        var selectedTemps = ""
        if store.isMetric == false {
            selectedTemps = store.tempsInF[row]
        } else {
            selectedTemps = store.tempsInC[row]
        }
        return selectedTemps
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //save the value for the pickerview temperature selected.
        if store.isMetric == false {
        selectedTemp = store.tempsInF[row]
        } else {
            selectedTemp = store.tempsInC[row]
        }
        saveButton.isEnabled = true
        saveButton.backgroundColor = Constants.Colors.scooter
    }
}
