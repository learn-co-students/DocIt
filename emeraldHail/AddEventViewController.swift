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
    
    @IBOutlet weak var eventViewTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var store = DataStore.sharedInstance
    let dobSelection = UIDatePicker()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        nameTextField.becomeFirstResponder()
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func saveEvent(_ sender: UIButton) {
        
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
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelEvent(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startDateDidBeginEditing(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        dateTextField.text = formatter.string(from: dobSelection.date).uppercased()
        
    }
    
    // MARK: - Methods
    
    func setupView() {
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        
        saveButton.isEnabled = true
        
        eventView.layer.cornerRadius = 10
        eventView.layer.borderColor = Constants.Colors.submarine.cgColor
        eventView.layer.borderWidth = 1
        
        eventViewTitle.text = store.buttonEvent
        
        dateTextField.delegate = self
        
        if eventViewTitle.text == "Modify Event" {
            
            nameTextField.text = store.event.name
            dateTextField.text = store.event.startDate
            
        }
        
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
