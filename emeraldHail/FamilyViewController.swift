//
//  FamilyViewController.swift
//  emeraldHail
//
//   Created by Tanira Wiggins on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // outlets
    @IBOutlet weak var familyName: UIButton!
    
    //    @IBOutlet weak var uploadPhotoLibraryView: UIImageView!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    
    // properties
    
    let imageSelected = UIImagePickerController()
    var membersInFamily = [Member]()
    
    // loads 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSelected.delegate = self
//        uploadPhotoLibraryView.image = UIImage(named: "blackfam")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        configDatabase()
        
        memberProfilesView.reloadData()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberProfilesView.reloadData()
    }
    
    @IBAction func changeFamilyName(_ sender: UIButton) {
        changeFamilyName()
    }
//    @IBAction func uploadPhotoGesture(_ sender: UITapGestureRecognizer) {
//        let myPickerController = UIImagePickerController()
//        myPickerController.delegate = self
//        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        
//        
//        self.present(myPickerController, animated: true, completion: nil)
//    }
    
    // methods for collectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersInFamily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
        let eachMember = membersInFamily[indexPath.row]
        cell.memberNameLabel?.text = eachMember.firstName
        Logics.sharedInstance.memberID = membersInFamily[indexPath.row].uniqueID
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Logics.sharedInstance.memberID = membersInFamily[indexPath.row].uniqueID
    }
    
    // methods
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboardView")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }

    func getFamilyID() {
        Logics.sharedInstance.familyID = (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    
    func configDatabase() {
        
        let membersRef = FIRDatabase.database().reference().child("members")
        let familyRef = membersRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        
        familyRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            
            var newItem = [Member]()
            
            for item in snapshot.children {
                
                let newMember = Member(snapshot: item as! FIRDataSnapshot)
                
                newItem.append(newMember)
            }
            
            self.membersInFamily = newItem
            self.memberProfilesView.reloadData()
        })
    }
    
    func changeFamilyName() {
        
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: "Change family name", message: "Give us a funny name", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            
            guard let name = nameTextField?.text, name != "" else { return }
            
            let databaseEventsRef = FIRDatabase.database().reference().child("family").child((FIRAuth.auth()?.currentUser?.uid)!)
            git sta
            let family = Family(name: name)
            
            databaseEventsRef.setValue(family.serialize(), withCompletionBlock: { error, dataRef in
            })
            
            print("Save Button Pressed")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
            print("Cancel Button Pressed")
        }
        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            
            self.familyName.titleLabel?.text = nameTextField?.text
        }
        
        present(alertController, animated: true, completion: nil)
    }

}
