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
            tempTypeLabel.text = temp.tempType
        }
    }
    
    let offSet: CGFloat = 40.0
    let circleRadius: CGFloat = 10.0
    
    let shapeLayer = CAShapeLayer()
    let lineLayer = CAShapeLayer()
    
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
        
        // Add circle to the contenView
        contentView.layer.addSublayer(shapeLayer)
        contentView.layer.addSublayer(lineLayer)
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        // Draw a circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: offSet, y: contentView.bounds.height/2), radius: CGFloat(circleRadius), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = Constants.Colors.cinnabar.cgColor
        shapeLayer.strokeColor = Constants.Colors.cinnabar.cgColor
        shapeLayer.lineWidth = 1.0
        circlePath.stroke()
        
        // Draw a line
        let linePath = UIBezierPath()
        let startPoint = CGPoint(x: offSet, y: 0)
        let endPoint = CGPoint(x: offSet, y: self.bounds.maxY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = Constants.Colors.cinnabar.cgColor
        lineLayer.strokeColor = Constants.Colors.cinnabar.cgColor
        lineLayer.lineWidth = 1.0
        linePath.stroke()
    }
    
}
