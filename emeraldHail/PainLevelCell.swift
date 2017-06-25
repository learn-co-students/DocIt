//
//  PainLevelCell.swift
//  emeraldHail
//
//  Created by Mirim An on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class PainLevelCell: UITableViewCell {
    
    @IBOutlet weak var painLevelView: PainLevelView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
