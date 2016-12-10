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
    
    // MARK: - Properties
    
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var store = DataStore.sharedInstance
    let dobSelection = UIDatePicker()
    

    // MARK: - Loads 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

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
        
        let databaseEventsRef = self.database.child(Constants.DatabaseChildNames.events).child(self.store.member.id).childByAutoId()
        
        let uniqueID = databaseEventsRef.key
        
        let event = Event(name: name, startDate: date, uniqueID: uniqueID)
        
        
        databaseEventsRef.setValue(event.serialize(), withCompletionBlock: { error, dataRef in
            
            self.nameTextField.text = ""
            self.dateTextField.text = ""
            
        })
        }
        
        else {
            
            guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
            
            let databaseEventsRef = self.database.child(Constants.DatabaseChildNames.events).child(self.store.member.id).child(self.store.eventID)
            
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
    
    // MARK: - Methods
    
    func setupView() {
        
        
        eventView.layer.cornerRadius = 10
        eventView.layer.borderColor = UIColor.lightGray.cgColor
        eventView.layer.borderWidth = 1
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        eventViewTitle.text = store.buttonEvent
        
        dateTextField.delegate = self
        
        if eventViewTitle.text == "Modify Event" {
            
            nameTextField.text = store.event.name
            dateTextField.text = store.event.startDate

            print(store.event.name)
            print(store.event.startDate)
            
        }
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
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
