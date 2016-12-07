//
//  AddMember.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class AddMember: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate {

    // MARK: Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!

    // MARK: - Properties

    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    let store = DataStore.sharedInstance


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

    func addProfileSettings() {
        addGestureRecognizer(imageView: profileImageView)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.setRounded()
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.layer.borderWidth = 0.5
    }


    @IBAction func save(_ sender: UIButton) {

        guard let name = firstNameField.text, name != "",
          let lastName = lastNameField.text, lastName != "",
          let dob = dateTextField.text, dob != "",
          let gender = genderTextField.text, gender != ""

          else { return }

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

                    let member = Member(profileImage: profileImageUrl, firstName: name, lastName: lastName, gender: gender, birthday: dob, bloodType: "", height: "", weight: "", allergies: "", id: uniqueID)


                    databaseMembersRef.setValue(member.serialize(), withCompletionBlock: { error, dataRef in

                        self.isHidden = true
                        self.firstNameField.text = ""
                        self.lastNameField.text = ""
                        self.dateTextField.text = ""
                        self.genderTextField.text = ""
                        self.profileImageView.image = UIImage(named: "adorablebaby")

                    })
                }

            })
        }

    }

    @IBAction func cancel(_ sender: UIButton) {
        self.isHidden = true
        self.firstNameField.text = ""
        self.lastNameField.text = ""
        self.dateTextField.text = ""
        self.genderTextField.text = ""
        self.profileImageView.image = UIImage(named: "adorablebaby")

    }

    // MARK: - Methods


    func commonInit() {

        Bundle.main.loadNibNamed("AddMember", owner: self, options: nil)

        firstNameField.delegate = self


        addSubview(contentView)

        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.darkGray.cgColor

        addProfileSettings()

        genderSelection.delegate = self
        genderTextField.inputView = genderSelection

    }


    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }

    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true

        self.contentView.viewController()?.present(picker
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

        self.dateTextField.inputView = dobSelection

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
