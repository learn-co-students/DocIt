//
//  Post.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class Post {
    
    var note: String
    
    init(note: String) {
        self.note = note
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String : Any]
        note = snapshotValue["note"] as! String
    }
    
    func serialize() -> [String: Any] {
        return ["note" : note]
    }
    
}
    
// TODO: We're not currently utilizing this enum

enum PostType {
    case symptom, temp, painLevel, note, photo
}
