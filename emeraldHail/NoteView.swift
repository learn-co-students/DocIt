//
//  NoteView.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/26/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class NoteView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    
    var post: Post! {
        didSet {
            noteLabel.text = post.note
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
        Bundle.main.loadNibNamed("NoteView", owner: self, options: nil)
        
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
        shapeLayer.fillColor = Constants.Colors.scooter.cgColor
        shapeLayer.strokeColor = Constants.Colors.scooter.cgColor
        shapeLayer.lineWidth = 1.0
        circlePath.stroke()
        
        // Draw a line
        let linePath = UIBezierPath()
        let startPoint = CGPoint(x: offSet, y: 0)
        let endPoint = CGPoint(x: offSet, y: self.bounds.maxY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = Constants.Colors.scooter.cgColor
        lineLayer.strokeColor = Constants.Colors.scooter.cgColor
        lineLayer.lineWidth = 1.0
        linePath.stroke()
    }


}
