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
    let dobSelection = UIDatePicker()
    
    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEvent(_ sender: UIButton) {
        Event.saveEvent(
            button: saveButton,
            eventViewTitle: eventViewTitle,
            nameTextField: nameTextField,
            dateTextField: dateTextField,
            controller: self)
    }
    
    @IBAction func cancelEvent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startDateDidBeginEditing(_ sender: Any) {
        formatDate()
    }
    
    // MARK: - Methods
    func setupView() {
        view.backgroundColor = Constants.Colors.transBlack
        eventView.docItStyleView()
        saveButton.docItStyle()
        cancelButton.docItStyle()
        nameTextField.docItStyle()
        dateTextField.docItStyle()
        eventViewTitle.text = Store.buttonEvent
        dateTextField.delegate = self
        if eventViewTitle.text == "Modify Event" {
            nameTextField.text = Store.event.name
            dateTextField.text = Store.event.startDate
        }
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        nameTextField.becomeFirstResponder()
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
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
