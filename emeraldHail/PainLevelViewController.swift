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
        
        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
        
//        cell.wasSelected()
        cell.painLevelImage.layer.borderWidth = 5.0
        cell.painLevelImage.layer.borderColor = UIColor.yellow.cgColor
        selectedPainLevel = painLevels[indexPath.item]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PainLevelCollectionViewCell
    
        //cell.wasDeselected()
        cell.painLevelImage.layer.borderWidth = 0.0
        cell.painLevelImage.layer.borderColor = UIColor.clear.cgColor

        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
