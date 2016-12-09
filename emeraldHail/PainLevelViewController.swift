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
        
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIButton) {
        
        if let painLevel = selectedPainLevel  {
            addPainLevel()
            saveButton.isEnabled = false
        
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Methods

    func setupView() {
        
        painView.layer.cornerRadius = 10
        painView.layer.borderColor = UIColor.lightGray.cgColor
        painView.layer.borderWidth = 1
        
        
        
        painLevelCollectionView.layer.cornerRadius = 10
        painLevelCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        painLevelCollectionView.backgroundColor = UIColor.white
        painLevelCollectionView.layer.borderWidth = 1
        painLevelCollectionView.tintColor = UIColor.darkGray
        
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return painLevels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PainLevelCollectionViewCell
        
        cell.painLevelImage.image = painLevels[indexPath.row].image
        cell.painLevelDescription.text = painLevels[indexPath.row].description
        
        if cell.isSelected == true {
            cell.wasSelected()
        }
        else if cell.isSelected == false {
            cell.wasDeselected()
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PainLevelCollectionViewCell else { return }
        selectedPainLevel = painLevels[indexPath.row]
        cell.wasSelected()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PainLevelCollectionViewCell else { return }
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
