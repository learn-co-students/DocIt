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
        case .noPain: return UIImage(named: "noPain")!
        case .mild: return UIImage(named: "mild")!
        case .moderate: return UIImage(named: "moderate")!
        case .severe: return UIImage(named: "severe")!
        case .verySevere: return UIImage(named: "verySevere")!
        case .excruciating: return UIImage(named: "excruciating")!
        }
    }
    
    var description: String {
        switch self {
        case .noPain: return "No Pain"
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        case .verySevere: return "Very Severe"
        case .excruciating: return "Excruciating"
            
        }
        
    }
    
    
}





