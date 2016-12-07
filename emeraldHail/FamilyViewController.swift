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
    
    // MARK: Properties
    
    let store = DataStore.sharedInstance
    let imageSelected = UIImagePickerController()
    var membersInFamily = [Member]()
    var family = [Family]()
    var refresher = UIRefreshControl()
    var profileImage: UIImageView!
    var imageString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Inside FamilyVC, the familyID is: \(store.family.id)")
        
        hideKeyboardWhenTappedAround()
        getFamilyID()
        
        imageSelected.delegate = self
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        configDatabaseFamily()
        configDatabaseMember()
        
        memberProfilesView.reloadData()
        
        // TODO: Pull to refresh tests
        
        self.memberProfilesView.alwaysBounceVertical = true
        refresher.tintColor = Constants.Colors.scooter
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        memberProfilesView.addSubview(refresher)
        
        configureLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberProfilesView.reloadData()
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
        
        self.flowLayout.itemSize = itemSize
        self.flowLayout.minimumInteritemSpacing = spacing
        self.flowLayout.minimumLineSpacing = spacing
        self.flowLayout.sectionInset = insets

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue...")
        
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
    
    // MARK: Collection view methods
    
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
            cell.profileImageView.sd_setImage(with: profileImgUrl)
            cell.memberNameLabel?.text = member.firstName
            
            return cell
        } else {
            let addMemberCell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "addMemberCell", for: indexPath) as! AddMemberCollectionViewCell
            
            return addMemberCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selecting a cell...")
        print("Cell at \(indexPath.row) selected!")
        
        if indexPath.row < membersInFamily.count {
            store.member.id = membersInFamily[indexPath.row].id
        } else {
            print("The selected cell is not valid in membersInFamily. You are probably selecting the addMemberCell.")
            return
        }
    }
    
    // MARK: Header resuable view
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView
            let familyPictureUrl = URL(string: store.familyPicture)
            
            headerView.familyNameLabel.text = store.family.name
            headerView.profileImage.sd_setImage(with: familyPictureUrl)
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: Functions
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FamilyViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func getFamilyID() {
        store.family.id = (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    // TODO: Rethink some of the variable names here and in configDatabaseFamily for clarity
    
    func configDatabaseMember() {
        let membersRef = FIRDatabase.database().reference().child("members")
        let familyRef = membersRef.child(store.family.id)
        
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
        let membersRef = FIRDatabase.database().reference().child("family")
        let familyRef = membersRef.child(store.family.id)
        
        familyRef.observe(.value, with: { snapshot in
            
            var dic = snapshot.value as! [String : Any]
            
            guard let familyName = dic["name"] else { return }
            self.store.family.name = familyName as? String
            
            guard let coverImgStr = dic["coverImageStr"] else { return }
            self.store.familyPicture = coverImgStr as! String
        })
    }
    
    func changeFamilyName() {
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: nil, message: "Change your family name", preferredStyle: .alert)
        let save = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            guard let name = nameTextField?.text, name != "" else { return }
            let databaseEventsRef = FIRDatabase.database().reference().child("family").child(self.store.family.id)
            
            // TODO: We shoul be handling all the errors properly
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
    
    func handleRefresh() {
        memberProfilesView.reloadData()
        refresher.endRefreshing()
    }
    
    
}

class MemberCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
}
