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
    
    @IBOutlet weak var uploadPhotoLibraryView: UIImageView!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    
    let imageSelected = UIImagePickerController()
    
    var membersInFamily: [Member] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSelected.delegate = self
        uploadPhotoLibraryView.image = UIImage(named: "defaultImage")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        
        firebaseReference()
        
        configDatabase()
        
        memberProfilesView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberProfilesView.reloadData()
    }
    
    @IBAction func uploadPhotoFromLibrary(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func addFamilyButton(_ sender: Any) {
        print("addFamilyButton pressed")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersInFamily.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberProfileCell", for: indexPath) as! CellCollectionViewCell
        
        cell.firstNameLabel.text = membersInFamily[indexPath.item].firstName
        cell.lastNameLabel.text = membersInFamily[indexPath.item].lastName
        cell.majorAllergenLabel.text = membersInFamily[indexPath.item].majorAllergens
        cell.dOBLabel.text = membersInFamily[indexPath.item].dateOfBirth
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item at indexpath.row: \(indexPath.row) selected!")
    }
    
    ///// Firebase Database Access
    func firebaseReference(){
        let databaseMembersRef = FIRDatabase.database().reference().child("Members")
        databaseMembersRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let snapDict = snapshot.value as? [String:AnyObject]{
                for child in snapDict{
                    guard let firstName = child.value["FirstName"] as? String else { return }
                    guard let lastName = child.value["LastName"] as? String else { return }
                    guard let dateOfBirth = child.value["DateOfBirth"] as? String else { return }
                    guard let majorAllergens = child.value["MajorAllergens"] as? String else { return }
                    
                    let member = Member(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, majorAllergens: majorAllergens)
                    
                    self.membersInFamily.insert(member, at: 0)
                    self.memberProfilesView.reloadData()
                }
            }
        })
    }
    
    //    func firebaseReference(){
    //        let databaseMembersRef = FIRDatabase.database().reference().child("Members")
    //
    //        databaseMembersRef.observe(.childAdded, with: { snapshot in
    //
    //            if let snapshotValue = snapshot.value as? [String : AnyObject] {
    //
    //                print(snapshot)
    //
    //                for child in snapshotValue{
    //                    guard let firstName = child.value["FirstName"] as? String else { return }
    //                    guard let lastName = child.value["LastName"] as? String else { return }
    //                    guard let dateOfBirth = child.value["DateOfBirth"] as? String else { return }
    //                    guard let majorAllergens = child.value["MajorAllergens"] as? String else { return }
    //
    //                    let newMember = Member(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, majorAllergens: majorAllergens)
    //
    //                    self.membersInFamily.append(newMember)
    //                    self.memberProfilesView.reloadData()
    //                }
    //            }
    //        })
    //    }
    
    func configDatabase() {
        
        // Henry: This method regenerates the family member data each time a snapshot is taken. Not the most efficient, but it works if the number of family members is minimal. Not idea for a chat message app, but for our use it should be okay.
        
        let membersRef = FIRDatabase.database().reference().child("Members")
        
        membersRef.observe(.value, with: { snapshot in
            
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
    
    
    
    
}
