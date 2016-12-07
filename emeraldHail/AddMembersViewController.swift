//
//  AddMembersViewController.swift
//  emeraldHail
//
//  Created by Luna An on 11/21/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AddMembersViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    
    let bloodSelection = UIPickerView()
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    let weightSelection = UIPickerView()
    let heightSelection = UIPickerView()
    var feet = String()
    var inches = String()
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileSettings()
        hideKeyboardWhenTappedAround()
        
        birthdayField.delegate = self
        
        bloodSelection.delegate = self
        bloodTextField.inputView = bloodSelection
        
        genderSelection.delegate = self
        genderTextField.inputView = genderSelection
        
        weightSelection.delegate = self
        weightTextField.inputView = weightSelection
        
        heightSelection.delegate = self
        heightTextField.inputView = heightSelection
        
    }
    
    // MARK: - Actions
    
    @IBAction func didPressSave(_ sender: Any) {
        
        guard let name = firstNameField.text, name != "",
            let lastName = lastNameField.text, lastName != "",
            let dob = birthdayField.text, dob != "",
            let blood = bloodTextField.text, blood != "",
            let gender = genderTextField.text, gender != "",
            let weight = weightTextField.text, weight != "",
            let height = heightTextField.text, height != "",
            let allergies = allergiesTextField.text, allergies != "" else { return }
        
        let disableSaveButton = sender as? UIButton
        disableSaveButton?.isEnabled = false
        
        let database: FIRDatabaseReference = FIRDatabase.database().reference()
        let databaseMembersRef = database.child("members").child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId()
        let uniqueID = databaseMembersRef.key
        
        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        let imageId = uniqueID
        let storageImageRef = storageRef.child("profileImages").child(imageId)
        
        if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.25) {
            
            storageImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print (error?.localizedDescription ?? "Error in saveButtonTapped in AddMembersViewController.swift" )
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let member = Member(profileImage: profileImageUrl, firstName: name, lastName: lastName, gender: gender, birthday: dob, bloodType: blood, height: height, weight: weight, allergies: allergies, id: uniqueID)
                    
                    
                    databaseMembersRef.setValue(member.serialize(), withCompletionBlock: { error, dataRef in
                        let _ = self.navigationController?.popViewController(animated: true)
                        
                    })
                }
                
            })
        }

        
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
    
        let _ = navigationController?.popViewController(animated: true)
    
    }
    
    
    // MARK: - Methods
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    
    func addProfileSettings() {
        addGestureRecognizer(imageView: profileImageView)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.setRounded()
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.layer.borderWidth = 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return false
    }
    
    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picked canceled")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        switch pickerView {
        case bloodSelection:
            return 1
        case genderSelection:
            return 1
        case weightSelection:
            return 1
        case heightSelection:
            return 2
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch pickerView {
            
        case bloodSelection:
            return store.bloodTypeSelections.count
        case genderSelection:
            return store.genderSelections.count
        case weightSelection:
            return store.weightSelections.count
        case heightSelection:
            if component == 0 {
                return store.heightSelectionsFeet.count
            } else {
                return store.heightSelections.count
            }
        default:
            break
        }
        return 0
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
            
        case bloodSelection:
            bloodTextField.text = store.bloodTypeSelections[row]
        case genderSelection:
            genderTextField.text = store.genderSelections[row]
        case weightSelection:
            weightTextField.text = store.weightSelections[row]
        case heightSelection:
     
            
            if component == 0 {
                 feet = store.heightSelectionsFeet[row]
                print("DID I GET SOME \(feet)")
                

            } else if component == 1 {
                 inches = store.heightSelections[row]
                print("DID I GET ALOT OF \(inches)")
                
            }
            
            heightTextField.text = "\(feet)\(inches)"
            default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case bloodSelection:
            return store.bloodTypeSelections[row]
        case genderSelection:
            return store.genderSelections[row]
        case weightSelection:
            return store.weightSelections[row]
        case heightSelection:
            if component == 0{
                return store.heightSelectionsFeet[row]
            } else {
                return store.heightSelections[row]
            }
            
        default:
            break
        }
        
        return ""
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        birthdayField.inputView = dobSelection
        genderTextField.inputView = genderSelection
        bloodTextField.inputView = bloodSelection
        heightTextField.inputView = heightSelection
        weightTextField.inputView = weightSelection
        dobSelection.datePickerMode = UIDatePickerMode.date
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        birthdayField.resignFirstResponder()
        heightTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return self.view.endEditing(true)
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        //        let myLocale = Locale(identifier: "en_US")
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MM-dd-yyyy"
        //        var calendar = Calendar(identifier: .gregorian)
        birthdayField.text = formatter.string(from: sender.date)
        
    }
    
}
