//
//  Extensions.swift
//  emeraldHail
//
//  Created by Henry Ly on 12/3/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import LocalAuthentication

// MARK: - Make circle profile pictures
extension UIImageView {
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setCornerRounded() {
        docItStyleView()
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    func docItStyle() {
        self.layer.borderWidth = 1
        docItStyleView()
        self.layer.borderColor = Constants.Colors.athensGray.cgColor
        self.backgroundColor = UIColor.white
    }
}

extension UIView {
    func docItStyleView() {
        self.layer.cornerRadius = 2
    }
}

extension UIButton {
    func docItStyle() {
        docItStyleView()
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.3
    }
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}


// MARK: - Get random color
extension UIColor {
    class func getDocitColor() -> UIColor {
        let docitColors: [UIColor] = [Constants.Colors.purpleCake, Constants.Colors.neonCarrot,  Constants.Colors.cinnabar, Constants.Colors.ufoGreen]
        let randomNum = arc4random_uniform(5)
        let randomColor = docitColors[Int(randomNum)]
        
        return randomColor
    }
    
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

extension UIViewController {
    
    func getTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: currentDate).uppercased()
    }
    
    func errorMessageAuthentication(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was canceled by application."
        case LAError.authenticationFailed.rawValue:
            message = "Authentication was not successful, because user failed to provide valid credentials."
        case LAError.userCancel.rawValue:
            message = "Authentication was canceled by user"
        case LAError.userFallback.rawValue:
            message = "Authentication was canceled, because the user tapped the fallback button."
        case LAError.systemCancel.rawValue:
            message = "Authentication was canceled by system."
        case LAError.passcodeNotSet.rawValue:
            message = "Authentication could not start, because passcode is not set on the device."
        case LAError.touchIDNotAvailable.rawValue:
            message = "Authentication could not start, because Touch ID is not available on the device."
        case LAError.touchIDNotEnrolled.rawValue:
            message = "Authentication could not start, because Touch ID has no enrolled fingers."
        default:
            message = "Did not find any error in LAError."
        }
        return message
    }
}

// For rotation
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
