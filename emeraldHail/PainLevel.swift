//
//  PainLevel.swift
//  emeraldHail
//
//  Created by Luna An on 11/27/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

enum PainLevel: Int {
    
    case noPain = 0
    case mild = 2
    case moderate = 4
    case severe = 6
    case verySevere = 8
    case excruciating = 10
    
    var image: UIImage {
        
        switch self {
        case .noPain: return UIImage(named: "Good")!
        case .mild: return UIImage(named: "notHappy")!
        case .moderate: return UIImage(named: "veryUnhappy")!
        case .severe: return UIImage(named: "Good")!
        case .verySevere: return UIImage(named: "notHappy")!
        case .excruciating: return UIImage(named: "veryUnhappy")!
        }
    }
    
    var description: String {
        switch self {
        case .noPain: return "0 - No Pain"
        case .mild: return "2 - Mild"
        case .moderate: return "4 - Moderate"
        case .severe: return "6 - Severe"
        case .verySevere: return "8 - Very Severe"
        case .excruciating: return "10 - Excruciating"
        }
        
    }
    
    
}





