//
//  AddMemberViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import Fusuma

class AddMemberViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate, FusumaDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var addMember: UIView!
    @IBOutlet weak var touchView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var touchDismiss: UITapGestureRecognizer!
    @IBOutlet weak var choosePhoto: UIButton!
    
    // MARK: - Properties
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()

    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    
    @IBAction func touchDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        Member.saveMember(
            button: saveButton,
            imageView: profileImageView,
            firstName: firstNameField.text,
            lastName: lastNameField.text,
            dob: dateTextField.text,
            gender: genderTextField.text)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressChoosePhoto(_ sender: Any) {
        handleCameraImage()
    }
    
    // MARK: - Methods
    
    func setupView() {
        addGestureRecognizer(imageView: profileImageView)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.setRounded()
        addMember.docItStyleView()
        let buttons: [UIButton] = [saveButton, cancelButton]
        let textFields: [UITextField] = [firstNameField, lastNameField, dateTextField, genderTextField]
        buttons.map { button in button.docItStyle() }
        textFields.map { textField in textField.docItStyle() }
        firstNameField.becomeFirstResponder()
        view.backgroundColor = Constants.Colors.transBlack
        genderTextField.inputView = genderSelection
        genderSelection.delegate = self
        dateTextField.delegate = self
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        choosePhoto.setRounded()
    }

    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraImage)))
    }
    
    @IBAction func birthdayDidBeginEditing(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        dateTextField.text = formatter.string(from: dobSelection.date).uppercased()
        
    }
    
    @IBAction func generDidBeginEditing(_ sender: Any) {
        genderTextField.text = Store.genderSelection[genderSelection.selectedRow(inComponent: 0)]
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if firstNameField.text != "" && lastNameField.text != "" && dateTextField.text != "" && genderTextField.text != "" {
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
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        dateTextField.text = formatter.string(from: sender.date).uppercased()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch pickerView {
        case genderSelection:
            return Store.genderSelection.count
        default:
            break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderSelection:
            genderTextField.text = Store.genderSelection[row]
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderSelection:
            return Store.genderSelection[row]
        default:
            break
        }
        return ""
    }
    
    // MARK: Fusuma
    func handleCameraImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion: nil)
        fusumaCropImage = true
        
    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        // present some alert with the image, add button to alert to send, upload from button
        print("Image selected")
    }

    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        profileImageView.image = image
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera access denied")
    }
}
