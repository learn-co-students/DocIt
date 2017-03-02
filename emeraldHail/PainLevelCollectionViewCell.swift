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
        painLevelImage.layer.borderWidth = 5.0
        painLevelImage.layer.borderColor = Constants.Colors.submarine.cgColor
        painLevelImage.layer.cornerRadius = 10
    }
    
    func wasDeselected(){
        painLevelImage.layer.borderWidth = 0.0
        painLevelImage.layer.borderColor = UIColor.clear.cgColor
        painLevelImage.layer.cornerRadius = 10
    }
    
}
