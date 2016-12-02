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
    
    // switch on instance of post to make computed property time
    // reach into the post type and set the time to the timestamp
    
    case note(Note)
    case temp(Temp)
    case pain(Pain)
    case symp(Symp)
    case photo(Photo)
    case noValue
    
    // Post now has uniqueID
    
    var description: String {
        
        switch self {
        case .note(let note): return note.uniqueID
        case .temp(let temp): return temp.uniqueID
        case .pain(let pain): return pain.uniqueID
        case .photo(let photo): return photo.uniqueID
        case .symp(let symp): return symp.uniqueID
        case .noValue: return "NO UNIQUE ID"
            
        }
        
    }
    
    var timestamp: String {
        
        switch self {
        case .note(let note): return note.timestamp
        case .temp(let temp): return temp.timestamp
        case .pain(let pain): return pain.timestamp
        case .photo(let photo): return photo.timestamp
        case .symp(let symp): return symp.timestamp
        case .noValue: return "NO TIMESTAMP"
            
        }
        
    }
    
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
        case "photo":
            let photo = Photo(dictionary: dictionary)
            self = .photo(photo)
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
