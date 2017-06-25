//
//  NoteCell.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/26/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var noteView: NoteView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
