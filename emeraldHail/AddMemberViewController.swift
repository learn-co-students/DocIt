//
//  AddMemberViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class AddMemberViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var addMember: UIView!
    @IBOutlet weak var credentialView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    // MARK: - Properties
    
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    let database = FIRDatabase.database().reference()
    
    let store = DataStore.sharedInstance
    
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
    
    
    @IBAction func save(_ sender: UIButton) {
        
        guard let name = firstNameField.text, name != "",
            let lastName = lastNameField.text, lastName != "",
            let dob = dateTextField.text, dob != "",
            let gender = genderTextField.text, gender != ""
            
            else { return }
        
        
        let databaseMembersRef = database.child("members").child(store.user.familyId).childByAutoId()
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
                    
                    let member = Member(profileImage: profileImageUrl, firstName: name, lastName: lastName, gender: gender, birthday: dob, bloodType: "", height: "", weight: "", allergies: "", id: uniqueID)
                    
                    
                    databaseMembersRef.setValue(member.serialize(), withCompletionBlock: { error, dataRef in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                }
                
            })
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    func setupView() {
        
        addGestureRecognizer(imageView: profileImageView)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.setRounded()
//        profileImageView.layer.borderColor = UIColor.gray.cgColor
//        profileImageView.layer.borderWidth = 0.5

        
        addMember.layer.cornerRadius = 10
        addMember.layer.borderColor = UIColor.lightGray.cgColor
        addMember.layer.borderWidth = 1
        
        credentialView.layer.cornerRadius = 10
        credentialView.layer.borderColor = UIColor.lightGray.cgColor
        credentialView.layer.borderWidth = 1
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        genderTextField.inputView = genderSelection
        genderSelection.delegate = self
        
        dateTextField.delegate = self
        
    }
    
    
    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.addMember.viewController()?.present(picker
            , animated: true, completion: nil)
        
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
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picked canceled")
        picker.dismiss(animated: true, completion: nil)
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
        formatter.dateFormat = "MM-dd-yyyy"
        dateTextField.text = formatter.string(from: sender.date)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch pickerView {
            
            
        case genderSelection:
            return store.genderSelections.count
            
        default:
            break
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case genderSelection:
            genderTextField.text = store.genderSelections[row]
            
        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case genderSelection:
            return store.genderSelections[row]
            
        default:
            break
        }
        
        return ""
    }
    

}
