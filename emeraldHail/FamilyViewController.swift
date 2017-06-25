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
import SDWebImage

class FamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    @IBOutlet weak var familySettings: UIBarButtonItem!
    @IBOutlet weak var imageDarkOverlay: UIView!
    
    // MARK: Properties
    let store = DataStore.sharedInstance
    var database = FIRDatabase.database().reference()
    
    let imageSelected = UIImagePickerController()
    var membersInFamily = [Member]()
    var family = [Family]()
    var refresher = UIRefreshControl()
    var profileImage: UIImageView!
    var imageString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        configDatabaseFamily()
        configDatabaseMember()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memberProfilesView.reloadData()
    }
    
    // MARK: - Methods
    func configureLayout() {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 12
        let insets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let widthDeductionPerItem: CGFloat = (spacing*(numberOfColumns-1) + insets.left + insets.right)/numberOfColumns
        let heightDeductionPerItem: CGFloat = (spacing*(numberOfColumns-1) + insets.top + insets.bottom)/numberOfColumns
        let itemSize = CGSize(width: screenWidth/numberOfColumns - widthDeductionPerItem, height: screenWidth/numberOfColumns - heightDeductionPerItem)
        
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = insets
        
        imageSelected.delegate = self
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        memberProfilesView.alwaysBounceVertical = true
        refresher.tintColor = Constants.Colors.scooter
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        memberProfilesView.addSubview(refresher)
        
        memberProfilesView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch sender {
        case is UICollectionViewCell:
            guard let indexPath = memberProfilesView.indexPath(for: sender as! UICollectionViewCell) else { return }
            if indexPath.row < membersInFamily.count {
                store.member.id = membersInFamily[indexPath.row].id
            }
        default:
            break
        }
    }
    
    // MARK: - Collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersInFamily.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < membersInFamily.count {
            let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
            let member = membersInFamily[indexPath.row]
            let profileImgUrl = URL(string: member.profileImage)
            cell.profileImageView.setRounded()
            cell.profileImageView.contentMode = .scaleAspectFill
            cell.profileImageView.sd_setImage(with: profileImgUrl, completed: { (image, error, cacheType, url) in
                cell.profileImageView.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    cell.profileImageView.alpha = 1
                })
            })
            cell.memberNameLabel?.text = member.firstName
            return cell
        } else {
            let addMemberCell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "addMemberCell", for: indexPath) as! AddMemberCollectionViewCell
            return addMemberCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < membersInFamily.count {
            let selectedMember = membersInFamily[indexPath.row]
            store.member.id = selectedMember.id
            store.member.firstName = selectedMember.firstName
            store.member.lastName = selectedMember.lastName
            store.member.allergies = selectedMember.allergies
            store.member.birthday = selectedMember.birthday
            store.member.bloodType = selectedMember.bloodType
            store.member.gender = selectedMember.gender
            store.member.height = selectedMember.height
            store.member.weight = selectedMember.weight
        } else {
            performSegue(withIdentifier: "addMember", sender: nil)
        }
    }
    
    // MARK: - Header resuable view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView
            let familyPictureUrl = URL(string: store.family.coverImageStr!)
            
            headerView.familyNameLabel.text = store.family.name
            
            headerView.alpha = 0
            
            if store.family.coverImageStr != "" {
                headerView.profileImage.sd_setImage(with: familyPictureUrl, completed: { (image, error, cacheType, url) in
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        headerView.alpha = 1
                    })
                })
            }
            else {
                headerView.profileImage?.image = UIImage(named: "Doc_It_BG")
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
        // TODO: What is going on here?
        let none = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "none", for: indexPath) as! HeaderCollectionReusableView
        
        return none
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FamilyViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    // TODO: Rethink some of the variable names here and in configDatabaseFamily for clarity
    func configDatabaseMember() {
        let familyRef = Database.members.child(store.user.familyId)
        
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
    
    // TODO: Rethink some of the variable names here for clarity
    func configDatabaseFamily() {
        let familyRef = Database.family.child(store.user.familyId)
        
        familyRef.observe(.value, with: { snapshot in
            
            var dic = snapshot.value as? [String : Any]
            
            guard let familyName = dic?["name"] else { return }
            self.store.family.name = familyName as? String
            
            guard let coverImgStr = dic?["coverImageStr"] else { return }
            self.store.family.coverImageStr = coverImgStr as? String
        })
    }
    
    func changeFamilyName() {
        var nameTextField: UITextField?
        let alertController = UIAlertController(title: nil, message: "Change your family name", preferredStyle: .alert)
        let save = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            guard let name = nameTextField?.text, name != "" else { return }
            let eventsRef = Database.family.child(self.store.user.familyId)
            // TODO: We should be handling all the errors properly
            eventsRef.updateChildValues(["name": name], withCompletionBlock: { (error, dataRef) in
            })
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
    
    func handleRefresh() {
        memberProfilesView.reloadData()
        refresher.endRefreshing()
    }
    
}

class MemberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
}
