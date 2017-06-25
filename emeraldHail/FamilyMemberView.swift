//
//  FamilyMemberView.swift
//  emeraldHail
//
//  Created by Henry Ly on 12/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FamilyMemberView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FamilyMemberView", owner: self, options: nil)
        addSubview(contentView)
        contentView.setConstraintEqualTo(left: leftAnchor, right: rightAnchor, top: topAnchor, bottom: bottomAnchor)
    }
}
