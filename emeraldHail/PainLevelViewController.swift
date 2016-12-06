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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Save button works only if selectedPainLevel is not nil
    
        if selectedPainLevel != nil {
            
        addPainLevel()
            
        // Disable the button after it's tapped with selectedPainLevel
        saveButton.isEnabled = false
            
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var painLevelCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Pain Level"
        painLevelCollectionView.allowsMultipleSelection = false
        
        painLevels = [noPain, mild, moderate, severe, verySevere, excruciating]
        
    }
    
    
    // MARK: CollectionView Funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return painLevels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PainLevelCollectionViewCell
        
        cell.painLevelImage.image = painLevels[indexPath.item].image
        cell.painLevelDescription.text = painLevels[indexPath.item].description
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
        
        cell.wasSelected()
        selectedPainLevel = painLevels[indexPath.item]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
        
        cell.wasDeselected()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func addPainLevel(){
        
        guard let painLevelDescription = selectedPainLevel?.description else { return }
        
        //let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss a"
        //let timestamp = dateFormatter.string(from: currentDate)
        
        // uniqueID added
        
        let databasePostContentRef = postRef.child(store.eventID).childByAutoId()
        let uniqueID = databasePostContentRef.key
        
        let newPain = Pain(content: painLevelDescription, timestamp: getTimestamp(), uniqueID: uniqueID)
        
        databasePostContentRef.setValue(newPain.serialize(), withCompletionBlock: {error, ref in
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
}
