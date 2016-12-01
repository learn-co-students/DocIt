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
    case pain(Pain)
    case symp(Symp)
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
            
        case "pain":
            let pain = Pain(dictionary: dictionary)
            self = .pain(pain)
            
        case "symp":
            let symp = Symp(dictionary: dictionary)
            self = .symp(symp)
            
        default:
            self = .noValue
            
        }
        
    }

}
//
//enum PostType: String {
//    
//    case note, temp
//
//    init(note: String) {
//        self.note = note
//    }
//    
//    init(snapshot: FIRDataSnapshot) {
//        let snapshotValue = snapshot.value as! [String : Any]
//        note = snapshotValue["note"] as! String
//    }
//    
//    func serialize() -> [String: Any] {
//        return ["note" : note]
//    }
//    
//
//}
