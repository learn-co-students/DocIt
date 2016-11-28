//
//  PainLevelCollectionViewCell.swift
//  emeraldHail
//
//  Created by Mirim An on 11/27/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class PainLevelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var painLevelImage: UIImageView!
    
    @IBOutlet weak var painLevelDescription: UILabel!
    
    func wasSelected(){
        layer.borderWidth = 5.0
        layer.borderColor = UIColor.yellow.cgColor
    }
    
    func wasDeselected(){
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        
    }
}
