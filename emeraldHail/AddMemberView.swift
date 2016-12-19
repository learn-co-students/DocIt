//
//  AddMemberView.swift
//  emeraldHail
//
//  Created by Henry Ly on 12/4/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class AddMemberView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var plusButton: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("AddMemberView", owner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowRadius = 1.0
        plusButton.layer.shadowOpacity = 0.3
    }
    
}
