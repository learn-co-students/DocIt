////
////  PainLevelViewController.swift
////  emeraldHail
////
////  Created by Luna An on 11/17/16.
////  Copyright © 2016 Flatiron School. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class PainLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    @IBAction func saveButtonTapped(_ sender: Any) {
//        
//        addPainLevel()
//        
//    }
//    @IBAction func cancelButtonTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    
//    let storage = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
//    
//    var selectedPainLevel: PainLevel?
// 
//    
//    @IBOutlet weak var painLevelCollectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.title = "Pain Level"
//        painLevelCollectionView.allowsMultipleSelection = false
//        
//    }
//    
//    
//    // MARK: CollectionView Funcs
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return painLevels.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PainLevelCollectionViewCell
//        
//        cell.painLevelImage.image = painLevels[indexPath.item].image
//        cell.painLevelDescription.text = painLevels[indexPath.item].description
//        
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
//        
//        cell.wasSelected()
//        selectedPainLevel = painLevels[indexPath.item]
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
//    
//        cell.wasDeselected()
//    
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func addPainLevel(){
//        let postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("posts")
//        
//        guard let painLevelDescription = selectedPainLevel?.description else {return}
//        let databasePostContentRef = postRef.child(Logics.sharedInstance.eventID).childByAutoId()
//   
//        let post = Post(note: painLevelDescription)
//        databasePostContentRef.setValue(post.serialize(), withCompletionBlock: {error, FIRDatabaseReference in
//            self.dismiss(animated: true, completion: nil)
//        
//        }
//)
//        
//    }
//    
//    func addPainLevelImageToStorage(){
//        
//    }
//
//}
