//
//  PainLevelViewController.swift
//  emeraldHail
//
//  Created by Luna An on 11/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class PainLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var painLevelCollectionView: UICollectionView!
    @IBOutlet weak var painView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    var noPain: PainLevel = .noPain
    var mild:PainLevel = .mild
    var moderate:PainLevel = .moderate
    var severe: PainLevel = .severe
    var verySevere: PainLevel = .verySevere
    var excruciating: PainLevel = .excruciating
    var painLevels = [PainLevel]()
    let storage = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
    var selectedPainLevel: PainLevel?
    let postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("posts")
    let store = DataStore.sharedInstance
    
    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pain Level"
        painLevelCollectionView.allowsMultipleSelection = false
        
        painLevels = [noPain, mild, moderate, severe, verySevere, excruciating]
        
        setupView()
        configureLayout()
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIButton) {
        saveButton.isEnabled = false
        addPainLevel()
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func configureLayout() {
        let viewWidth = painLevelCollectionView.bounds.width
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 12
        let insets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let widthDeductionPerItem: CGFloat = (spacing*(numberOfColumns-1) + insets.left + insets.right)/numberOfColumns
        let heightDeductionPerItem: CGFloat = (spacing*(numberOfColumns-1) + insets.top + insets.bottom)/numberOfColumns
        let itemSize = CGSize(width: viewWidth/numberOfColumns - widthDeductionPerItem, height: viewWidth/numberOfColumns - heightDeductionPerItem)
        
        self.collectionViewFlowLayout.itemSize = itemSize
        self.collectionViewFlowLayout.minimumInteritemSpacing = spacing
        self.collectionViewFlowLayout.minimumLineSpacing = spacing
        self.collectionViewFlowLayout.sectionInset = insets
    }
    
    
    func setupView() {
        postTitleLabel.text = "How does \(store.member.firstName) feel?"
        
        view.backgroundColor = Constants.Colors.transBlack
        
        painView.docItStyleView()
        saveButton.docItStyle()
        cancelButton.docItStyle()
        painLevelCollectionView.docItStyleView()
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return painLevels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PainLevelCollectionViewCell
        
        cell.painLevelImage.image = painLevels[indexPath.row].image
        cell.painLevelDescription.text = painLevels[indexPath.row].description
        
        if cell.isSelected == true {
            cell.backgroundColor = Constants.Colors.submarine
        }
        else if cell.isSelected == false {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PainLevelCollectionViewCell else { return }
        selectedPainLevel = painLevels[indexPath.row]
        
        cell.backgroundColor = Constants.Colors.submarine
        cell.layer.cornerRadius = 10
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = Constants.Colors.scooter
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PainLevelCollectionViewCell else { return }
        
        cell.backgroundColor = UIColor.clear
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func addPainLevel() {
        guard let painLevelDescription = selectedPainLevel?.description else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss a"
        
        let databasePostContentRef = postRef.child(store.eventID).childByAutoId()
        let uniqueID = databasePostContentRef.key
        
        let newPain = Pain(content: painLevelDescription, timestamp: getTimestamp(), uniqueID: uniqueID)
        
        databasePostContentRef.setValue(newPain.serialize(), withCompletionBlock: {error, ref in
            self.dismiss(animated: true, completion: nil)
            // TODO: Handle error
        })
    }
    
}
