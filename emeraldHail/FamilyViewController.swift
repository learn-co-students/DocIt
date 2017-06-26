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
    var refresher = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        Family.configDatabaseFamily(database: Database.family, familyId: Store.user.familyId)
//        configDatabaseMember()
                Family.configDatabaseMember(database: Database.members, familyId: Store.family.id, collectionView: memberProfilesView)
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
            if indexPath.row < Store.members.count {
                Store.member.id = Store.members[indexPath.row].id
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
        return Store.members.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < Store.members.count {
            let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
            let member = Store.members[indexPath.row]
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
        if indexPath.row < Store.members.count {
            let selectedMember = Store.members[indexPath.row]
            Store.member = selectedMember
        } else {
            performSegue(withIdentifier: "addMember", sender: nil)
        }
    }
    
    // MARK: - Header resuable view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView
            let familyPictureUrl = URL(string: Store.family.coverImageStr!)
            
            headerView.familyNameLabel.text = Store.family.name
            
            headerView.alpha = 0
            
            if Store.family.coverImageStr != "" {
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

    func handleRefresh() {
        memberProfilesView.reloadData()
        refresher.endRefreshing()
    }
}

class MemberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
}
