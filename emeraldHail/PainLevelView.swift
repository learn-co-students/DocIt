//
//  PainLevelView.swift
//  emeraldHail
//
//  Created by Mirim An on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class PainLevelView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var painLevelLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    var pain: Pain! {
        didSet {
        
            painLevelLabel.text = pain.content
            timestampLabel.text = pain.naturalTime
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PainLevelView", owner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        
        timestampLabel.textColor = Constants.Colors.submarine
        
//        contentView.backgroundColor = UIColor.getRandomColor()
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        drawTimeline(circleColor: Constants.Colors.neonCarrot.cgColor, lineColor: Constants.Colors.neonCarrot.cgColor)
    }
    
    
}
