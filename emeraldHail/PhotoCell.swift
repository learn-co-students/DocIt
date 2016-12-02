//
//  PhotoCell.swift
//  emeraldHail
//
//  Created by Mirim An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var PhotoView: PhotoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
