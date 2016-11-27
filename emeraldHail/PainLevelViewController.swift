//
//  PainLevelViewController.swift
//  emeraldHail
//
//  Created by Luna An on 11/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class PainLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var painLevelCollectionView: UICollectionView!
    
    
    
    var selectedFace: UIImage?
    var selectedPainLevel: PainLevel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pain Level"
        painLevelCollectionView.allowsMultipleSelection = false

    }
    
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
        selectedPainLevel = painLevels[indexPath.item]
        print("Selected pain level is \(selectedPainLevel)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedPainLevel = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
        
        if selectedPainLevel == painLevels[indexPath.item] {
            cell.wasDeselected()
            selectedPainLevel = nil
        } else {
            selectedPainLevel = painLevels[indexPath.item]
            cell.wasSelected()
        }
        return true
    }
  
}
