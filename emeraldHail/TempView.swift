//
//  TempView.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TempView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tempTypeLabel: UILabel!
    
    
    var temp: Temp! {
        didSet {
            tempLabel.text = temp.content + "º"
            timestampLabel.text = temp.naturalTime
            tempTypeLabel.text = temp.tempType.uppercased()
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
        Bundle.main.loadNibNamed("TempView", owner: self, options: nil)
        
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
        drawTimeline(circleColor: Constants.Colors.cinnabar.cgColor, lineColor: Constants.Colors.submarine.cgColor)
    }
    
}
