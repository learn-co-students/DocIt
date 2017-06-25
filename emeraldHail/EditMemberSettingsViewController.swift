//
//  EditMemberSettingsViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import Fusuma

class EditMemberSettingsViewController: UITableViewController, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, FusumaDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var allergiesTextField: UITextField!
    @IBOutlet weak var deleteMember: UIButton!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    let bloodSelection = UIPickerView()
    let dobSelection = UIDatePicker()
    let genderSelection = UIPickerView()
    let weightSelection = UIPickerView()
    let heightSelection = UIPickerView()
    var feet = String()
    var inches = String()
    var meter = String()
    var centimeter = "0"
    var kg = "0"
    var g = "0"
    
    // MARK: - Loads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let measurementSystem = UserDefaults.standard.value(forKey: "isMetric") as? Bool {
            if measurementSystem == true {
                Store.isMetric = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileSettings()
        displayMemberProfileEdits()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func didPressSave(_ sender: UIButton) {
        Member.saveEditedMember(
            sender: sender,
            indicatorView: activityIndicatorView,
            firstName: firstNameTextField,
            lastName: lastNameTextField,
            dob: dobTextField,
            gender: genderTextField,
            height: heightTextField,
            weight: weightTextField,
            blood: bloodTextField,
            profilePicture: profilePicture,
            allergies: allergiesTextField,
            controller: self)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressDeleteMember(_ sender: UIButton) {
        Member.deleteMember(button: sender, controller: self)
    }
    
    // MARK: - Methods
    @IBAction func genderEditingDidBegin(_ sender: Any) {
        genderTextField.text = Store.genderSelection[genderSelection.selectedRow(inComponent: 0)]
    }
    
    @IBAction func heightEditingDidBegin(_ sender: Any) {
        if Store.isMetric == false {
            heightTextField.text = Store.heightsInInches[heightSelection.selectedRow(inComponent: 0)] + Store.heightsInFeet[heightSelection.selectedRow(inComponent: 1)]
        } else {
            heightTextField.text = Store.heightsInMeter[heightSelection.selectedRow(inComponent: 0)] + Store.heightsInCm[heightSelection.selectedRow(inComponent: 1)]
        }
    }
    @IBAction func weightEditingDidBegin(_ sender: Any) {
        weightTextField.text = Store.weightsInLbs[weightSelection.selectedRow(inComponent: 0)]
    }
    
    @IBAction func bloodTypeEditingDidBegin(_ sender: Any) {
        bloodTextField.text = Store.bloodTypeSelections[bloodSelection.selectedRow(inComponent: 0)]
    }
    
    @IBAction func birthdayEditingDidBegin(_ sender: Any) {
        let dobSelection = UIDatePicker()
        dobTextField.inputView = dobSelection
        dobSelection.datePickerMode = UIDatePickerMode.date
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    @IBAction func didPressChangePhoto(_ sender: Any) {
        handleCameraImage()
    }
    
    func setupViews() {
        bloodSelection.delegate = self
        genderSelection.delegate = self
        weightSelection.delegate = self
        heightSelection.delegate = self
        
        bloodTextField.inputView = bloodSelection
        genderTextField.inputView = genderSelection
        weightTextField.inputView = weightSelection
        heightTextField.inputView = heightSelection
    }

    // MARK: - Methods
    func addProfileSettings() {
        addGestureRecognizer(imageView: profilePicture)
        profilePicture.isUserInteractionEnabled = true
        profilePicture.setRounded()
    }
    
    func addGestureRecognizer(imageView: UIImageView){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCameraImage)))
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func displayMemberProfileEdits() {
        let member = Database.members.child(Store.user.familyId).child(Store.member.id)
        member.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String : Any]
            let imageString = value?["profileImage"] as? String
            guard let imgUrl = imageString else { return }
            let profileImgUrl = URL(string: imgUrl)
            let firstName = value?["firstName"] as? String
            let lastName = value?["lastName"] as? String
            let gender = value?["gender"] as? String
            let bloodType = value?["bloodType"] as? String
            let birthday = value?["birthday"] as? String
            let height = value?["height"] as? String
            let weight = value?["weight"] as? String
            let allergies = value?["allergies"] as? String
            
            self.firstNameTextField.text = firstName
            self.lastNameTextField.text = lastName
            self.genderTextField.text = gender
            self.dobTextField.text = birthday
            self.bloodTextField.text = bloodType
            self.allergiesTextField.text = allergies
            self.heightTextField.text = height
            self.weightTextField.text = weight
            self.profilePicture.sd_setImage(with: profileImgUrl)
            self.profilePicture.setRounded()
            self.profilePicture.contentMode = .scaleAspectFill
        })
    }
    
    // MARK: Methods Picker View
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dobSelection = UIDatePicker()
        dobTextField.inputView = dobSelection
        dobSelection.datePickerMode = UIDatePickerMode.date
        dobSelection.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dobTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.view.endEditing(true)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        
        dobTextField.text = formatter.string(from: sender.date).uppercased()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        if Store.isMetric == false {
            switch pickerView {
            case bloodSelection, genderSelection, weightSelection:
                return 1
            case heightSelection:
                return 2
            default:
                return 1
            }
        } else {
            switch pickerView {
            case bloodSelection, genderSelection:
                return 1
            case weightSelection, heightSelection:
                return 2
            default:
                return 1
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if Store.isMetric == false {
            switch pickerView {
            case bloodSelection:
                return Store.bloodTypeSelections.count
            case genderSelection:
                return Store.genderSelection.count
            case weightSelection:
                return Store.weightsInLbs.count
            case heightSelection:
                if component == 0 {
                    return Store.heightsInFeet.count
                } else if component == 1 {
                    return Store.heightsInInches.count
                }
            default:
                break
            }
            return 0
        } else {
            switch pickerView {
            case bloodSelection:
                return Store.bloodTypeSelections.count
            case genderSelection:
                return Store.genderSelection.count
            case weightSelection:
                if component == 0 {
                    return Store.weightsInKg.count
                } else if component == 1 {
                    return Store.weightsInG.count
                }
            case heightSelection:
                if component == 0 {
                    return Store.heightsInMeter.count
                } else if component == 1 {
                    return Store.heightsInCm.count
                }
            default:
                break
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if Store.isMetric == false {
            switch pickerView {
            case bloodSelection:
                bloodTextField.text = Store.bloodTypeSelections[row]
            case genderSelection:
                genderTextField.text = Store.genderSelection[row]
            case weightSelection:
                weightTextField.text = Store.weightsInLbs[row]
            case heightSelection:
                if component == 0 {
                    feet = Store.heightsInFeet[row]
                } else if component == 1 {
                    inches = Store.heightsInInches[row]
                }
                heightTextField.text = "\(feet)\(inches)"
            default:
                break
            }
        } else {
            switch pickerView {
            case bloodSelection:
                bloodTextField.text = Store.bloodTypeSelections[row]
            case genderSelection:
                genderTextField.text = Store.genderSelection[row]
            case weightSelection:
                if component == 0 {
                    kg = Store.weightsInKg[row]
                } else if component == 1 {
                    g = Store.weightsInG[row]
                }
                
                weightTextField.text = "\(kg).\(g) kg"
                
            case heightSelection:
                if component == 0 {
                    meter = Store.heightsInMeter[row]
                } else if component == 1 {
                    centimeter = Store.heightsInCm[row]
                }
                if meter == " - " {
                    heightTextField.text = "\(centimeter)"
                } else {
                    heightTextField.text = "\(meter) \(centimeter)"
                }
            default:
                break
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var width = CGFloat(100.0)
        if Store.isMetric == true {
            switch pickerView {
            case weightSelection:
                width = 65.0
            default:
                width = 100.0
            }
        }
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if Store.isMetric == false {
            switch pickerView {
            case bloodSelection:
                return Store.bloodTypeSelections[row]
            case genderSelection:
                return Store.genderSelection[row]
            case weightSelection:
                return Store.weightsInLbs[row]
            case heightSelection:
                if component == 0 {
                    return Store.heightsInFeet[row]
                } else if component == 1 {
                    return Store.heightsInInches[row]
                }
            default:
                break
            }
            return ""
        } else {
            switch pickerView {
            case bloodSelection:
                return Store.bloodTypeSelections[row]
            case genderSelection:
                return Store.genderSelection[row]
            case weightSelection:
                if component == 0 {
                    return "\(Store.weightsInKg[row]) ."
                } else if component == 1 {
                    return "\(Store.weightsInG[row]) kg"
                }
            case heightSelection:
                if component == 0 {
                    return Store.heightsInMeter[row]
                } else if component == 1 {
                    return Store.heightsInCm[row]
                }
            default:
                break
            }
            return ""
        }
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
        // present some alert with the image
        // add button to alert to send
        // upload from button)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        profilePicture.image = image
    }

    //Called just after a video has been selected.
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    // When camera roll is not authorized, this method is called. Camera access denied
    func fusumaCameraRollUnauthorized() {
        // TODO: Handle what happens when the camera is not authorized
    }
}
