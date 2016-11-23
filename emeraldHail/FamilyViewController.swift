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

var imageCache = [String: UIImage]()

class FamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // outlets
    @IBOutlet weak var familyName: UIButton!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    
    // properties
    
    let imageSelected = UIImagePickerController()
    var membersInFamily = [Member]()
    var family = [Family]()
    
    // loads 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        getFamilyID()
        
        imageSelected.delegate = self
//        uploadPhotoLibraryView.image = UIImage(named: "blackfam")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        configDatabaseFamily()
        configDatabaseMember()
        
        memberProfilesView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberProfilesView.reloadData()
    }
    
    // actions 
    
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
        let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberViewCollectionCellCollectionViewCell
        
        let member = membersInFamily[indexPath.row]
        
        if cell.memberView.delegate == nil { cell.memberView.delegate = self }
        
        cell.member = member
        
        // TODO: What is this?
        Logics.sharedInstance.memberID = member.uniqueID
        
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FamilyViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }

    func getFamilyID() {
        Logics.sharedInstance.familyID = (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    
    func configDatabaseMember() {
        
        let membersRef = FIRDatabase.database().reference().child("members")
        let familyRef = membersRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        
        familyRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            
            var newItem = [Member]()
            
            // TODO: Don't re-add new members IF they already exist in our membersInFamily array.
            // TODO:
            for item in snapshot.children {
                
                let newMember = Member(snapshot: item as! FIRDataSnapshot)
                
                if self.membersInFamily.contains(newMember) { continue }
                
                newItem.append(newMember)
            }
            
            self.membersInFamily = newItem
            self.memberProfilesView.reloadData()
        })
    }
    
    func configDatabaseFamily() {
        
        let membersRef = FIRDatabase.database().reference().child("family")
        let familyRef = membersRef.child(Logics.sharedInstance.familyID)
        
        familyRef.observe(.value, with: { snapshot in
            
            var name = snapshot.value as! [String:Any]
            
            self.familyNameLabel.text = name["name"] as? String
    })
}

    func changeFamilyName() {
        
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: "Change family name", message: "Give us a funny name", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            guard let name = nameTextField?.text, name != "" else { return }
            let databaseEventsRef = FIRDatabase.database().reference().child("family").child(Logics.sharedInstance.familyID)
            databaseEventsRef.updateChildValues(["name": name], withCompletionBlock: { (error, dataRef) in
            })
            print("Save Button Pressed")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
            print("Cancel Button Pressed")
        }
        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            
            nameTextField = textField
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Image Delegate

extension FamilyViewController: ImageDelegate {
    
    func canDisplayImage(member: Member) -> Bool {
        
        var visibleMemberIDS: [String] = []
        
        let indexPaths = memberProfilesView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            
            let idOfMember = membersInFamily[indexPath.row].uniqueID
            
            visibleMemberIDS.append(idOfMember)
            
        }
        
        return visibleMemberIDS.contains(member.uniqueID)
        
    }
    
    
    
}


