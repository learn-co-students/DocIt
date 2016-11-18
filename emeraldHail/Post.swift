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
        
    var timestamp: Date
    
    var temp: Double?
    
    var photo: UIImage?
    var photoStr: String?
    var note: String?
    var painLevel: PainLevel?
    
    init(id: String, postType: PostType, timestamp: Date, sympotoms: Symptom?, temp: Double?, photo: UIImage?, note: String?, painLevel: PainLevel?) {
     
        self.id = id
//        self.postType = postType
        self.timestamp = timestamp
        
        self.postType = postType
        
        self.note = note
        
//        self.symptoms = sympotoms
     
        
//        switch postType {
//            
//        case .note:
//            self.note = note
//        case .symptom:
//            self.symptoms = symptoms
//        case .photo:
//            self.photo = photo
//            
//        }
    }
    
    
    
    //
    
    
}

enum PostType {
    
    case symptom, temp, painLevel, note, photo
    
}
