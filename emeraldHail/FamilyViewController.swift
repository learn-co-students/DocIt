//
//  FamilyViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // OUTLETS
    
    @IBOutlet weak var familyName: UIButton!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    
    // PROPERTIES
    
    let imageSelected = UIImagePickerController()
    var membersInFamily = [Member]()
    var family = [Family]()
    
    // LOADS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        getFamilyID()
        
        imageSelected.delegate = self
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
    
    // ACTIONS
    
    @IBAction func changeFamilyName(_ sender: UIButton) {
        changeFamilyName()
    }
        
    // COLLECTION VIEW METHODS
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersInFamily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
        let member = membersInFamily[indexPath.row]
        cell.memberNameLabel?.text = member.firstName
        cell.profileImageView.image = UIImage(named: "kid_silhouette")
        cell.profileImageView.contentMode = .scaleAspectFill
        cell.profileImageView.setRounded()
        
        if let profileImageUrl = member.profileImage {
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    print("Error occurred")
                    return
                }
                
                OperationQueue.main.addOperation {
                    cell.profileImageView.image = UIImage(data: data!)
                }
            }).resume()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logics.sharedInstance.memberID = membersInFamily[indexPath.row].uniqueID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backButton
    }
    
    // METHODS
    
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
            
            var newItem = [Member]()
            
            for item in snapshot.children {
                
                let newMember = Member(snapshot: item as! FIRDataSnapshot)
                
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

class MemberCollectionViewCell: UICollectionViewCell {
    
    // OUTLETS
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
}
