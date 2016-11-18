//
//  Post.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

final class Post {
    
    var id: String
    var postType: PostType
    
    var symptoms: [Symptom] = []
    var temp: Double?
    var photo: UIImage?
    var note: String?
    var painLevel: PainLevel?
    
    
    
    
}

enum PostType {
    
    case symptom, temp, painLevel, note, photo
    
}
