//
//  SymptomCell.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SymptomCell: UITableViewCell {
    
    @IBOutlet weak var symptomView: SymptomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
