//
//  Post.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias TimeStamp = [AnyHashable : Any]

enum Post {
    
    case note(Note)
    case temp(Temp)
    case noValue
    
    init(dictionary: [String : Any]) {
        
        let type = dictionary["postType"] as! String
        
        switch type {
            
        case "note":
            let note = Note(dictionary: dictionary)
            self = .note(note)
            
        case "temp":
            let temp = Temp(dictionary: dictionary)
            self = .temp(temp)
            
        default:
            self = .noValue
            
        }
        
    }

}

enum PostType: String {
    case note, temp
}
