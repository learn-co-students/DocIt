//
//  Extensions.swift
//  emeraldHail
//
//  Created by Henry Ly on 12/3/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

// MARK: - Make circle profile pictures

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}

// MARK: - Get random color

extension UIColor {
    class func getRandomColor() -> UIColor {
        let red: CGFloat = CGFloat(drand48())
        let green: CGFloat = CGFloat(drand48())
        let blue: CGFloat = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.7)
    }
}

// MARK: - Drawing the timeline

extension UIView {
    
    func drawTimeline(circleColor: CGColor, lineColor: CGColor) {
    
        let shapeLayer = CAShapeLayer()
        let lineLayer = CAShapeLayer()
        
        self.layer.addSublayer(lineLayer)
        self.layer.addSublayer(shapeLayer)
        
        // Draw a circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: Constants.CustomCell.offset, y: self.bounds.height/2), radius: CGFloat(Constants.CustomCell.bulletRadius), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = circleColor
        shapeLayer.strokeColor = circleColor
        shapeLayer.lineWidth = Constants.CustomCell.lineWidth
        circlePath.stroke()
        
        // Draw a line
        let linePath = UIBezierPath()
        let startPoint = CGPoint(x: Constants.CustomCell.offset, y: 0)
        let endPoint = CGPoint(x: Constants.CustomCell.offset, y: self.bounds.maxY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = lineColor
        lineLayer.strokeColor = lineColor
        lineLayer.lineWidth = Constants.CustomCell.lineWidth
        linePath.stroke()
        
    }
    
}

