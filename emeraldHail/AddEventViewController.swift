//
//  AddEventViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class AddEventViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var touchView: UIView!
    @IBOutlet weak var eventViewTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var store = DataStore.sharedInstance
    let dobSelection = UIDatePicker()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissView(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func saveEvent(_ sender: UIButton) {
       saveEvent()
    }
    
    
    @IBAction func cancelEvent(_ sender: UIButton) {
        dismissViewController()
    }
    
    @IBAction func startDateDidBeginEditing(_ sender: Any) {
        formatDate()
    }
    
    // MARK: - Methods
    
    func setupView() {
        
        view.backgroundColor = Constants.Colors.transBlack
        
        saveButton.isEnabled = true
        saveButton.docItStyle()
        
        cancelButton.docItStyle()
        eventView.docItStyleView()
        
        nameTextField.docItStyle()

        
        
        dateTextField.docItStyle()
        
        
        eventViewTitle.text = store.buttonEvent
        
        dateTextField.delegate = self
        
        if eventViewTitle.text == "Modify Event" {
            
            nameTextField.text = store.event.name
            dateTextField.text = store.event.startDate
            
        }
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        
        nameTextField.becomeFirstResponder()
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveEvent() {
        saveButton.isEnabled = false
        
        if eventViewTitle.text == "Create Event" {
            
            guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
            
            let databaseEventsRef = self.database.child(Constants.Database.events).child(self.store.member.id).childByAutoId()
            
            let uniqueID = databaseEventsRef.key
            
            let event = Event(name: name, startDate: date, uniqueID: uniqueID)
            
            databaseEventsRef.setValue(event.serialize(), withCompletionBlock: { error, dataRef in
                
                self.nameTextField.text = ""
                self.dateTextField.text = ""
                
            })
            
        }
            
        else {
            
            guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
            
            let databaseEventsRef = self.database.child(Constants.Database.events).child(self.store.member.id).child(self.store.eventID)
            
            let uniqueID = databaseEventsRef.key
            
            let event = Event(name: name, startDate: date, uniqueID: uniqueID)
            
            databaseEventsRef.updateChildValues(event.serialize(), withCompletionBlock: { error, dataRef in
                
                
            })
            
        }
        
        dismissViewController()
    }
    
    func formatDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        dateTextField.text = formatter.string(from: dobSelection.date).uppercased()

    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if nameTextField.text != "" && dateTextField.text != ""  {
            
            saveButton.isEnabled = true
            saveButton.backgroundColor = Constants.Colors.scooter
            
        }

        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        dateTextField.inputView = dobSelection
        
        dobSelection.datePickerMode = UIDatePickerMode.date
        
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        dateTextField.text = formatter.string(from: sender.date).uppercased()
        
    }
    
    
    
}
