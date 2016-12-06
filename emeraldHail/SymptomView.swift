
//
//  SymptomView.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SymptomView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var symptoms = [String]()
    
    var symp: Symp! {
        didSet {
            
            for key in symp.content.keys {
                guard let value = symp.content[key] else { return }
                symptoms.append(value)
            }
            
            symptomLabel.text = symptoms.joined(separator: ", ")
            symptoms.removeAll()
            
            timestampLabel.text = symp.naturalTime
            
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
        Bundle.main.loadNibNamed("SymptomView", owner: self, options: nil)
        
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
        drawTimeline(circleColor: Constants.Colors.ufoGreen.cgColor, lineColor: Constants.Colors.submarine.cgColor)
    }
    
}
