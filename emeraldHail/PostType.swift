//
//  PostType.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit


protocol Content {

    var symptoms: [Symptom]? { get }
    var photo: UIImage? { get }
    var note: String? { get }
    var painLevel: PainLevel? { get }
    
    
    
    
}



