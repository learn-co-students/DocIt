//
//  MemberViewCollectionCellCollectionViewCell.swift
//  emeraldHail
//
//  Created by Mirim An on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MemberViewCollectionCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memberView: MemberView!
    
    var member: Member! {
        
        didSet {
            
            memberView.member = member
        
        }
        
    }
    
}
