//
//  AddEvent.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class AddEvent: UIView, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    // MARK: - Properties
    
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var store = DataStore.sharedInstance
    let dobSelection = UIDatePicker()
    
    // MARK: - Loads
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Actions
    
    @IBAction func saveEvent(_ sender: UIButton) {
        
        guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
        
        let databaseEventsRef = self.database.child("events").child(self.store.member.id).childByAutoId()
        
        let uniqueID = databaseEventsRef.key
        
        let event = Event(name: name, startDate: date, uniqueID: uniqueID)
        
        clear()
        
        databaseEventsRef.setValue(event.serialize(), withCompletionBlock: { error, dataRef in
            
            self.isHidden = true
            self.nameTextField.text = ""
            self.dateTextField.text = ""
            
        })
    }
    
    @IBAction func cancelEvent(_ sender: UIButton) {
        clear()
    }
    
    // MARK: - Methods
    
    func commonInit() {
        Bundle.main.loadNibNamed("AddEvent", owner: self, options: nil)
        
        dateTextField.delegate = self
        
        addSubview(contentView)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = Constants.Colors.submarine.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func clear() {
        
        self.isHidden = true
        self.nameTextField.text = ""
        self.dateTextField.text = ""
        self.dobSelection.setDate(NSDate() as Date, animated: true)
        
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
