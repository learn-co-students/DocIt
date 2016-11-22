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
        
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        note = snapshotValue["note"] as! String
        
    }
    
    func serialize() -> [String: Any] {
        
        return ["note" : note]
    }
    
}

    //post properties
//    var id: String
//    var postType: PostType
//    
//    var content: Content! {
//        didSet {
//            
//            switch content {
//                
//            case is Symptom:
//                
//                cell = tableView.dequereusableCell(at: IndexPath) as! SymptomCell
//                cell.symptom = post.content as! Symptom
//                
//                print("Hi")
//            case is PainLevel:
//                print("Pain")
//            default:
//                fatalError("Nope.")
//                
//                
//            }
//            
//        }
//    }
//        
//    var timestamp: Date
//    
//    var temp: Double?
//    
//    var photo: UIImage?
//    var photoStr: String?
//    var note: String
//    var painLevel: PainLevel?
//    
//    init(id: String, postType: PostType, timestamp: Date, sympotoms: Symptom?, temp: Double?, photo: UIImage?, note: String?, painLevel: PainLevel?) {
//     
//        self.id = id
////        self.postType = postType
//        self.timestamp = timestamp
//        
//        self.postType = postType
//        
//        self.note = note
//        
////        self.symptoms = sympotoms
//     
//        
////        switch postType {
////            
////        case .note:
////            self.note = note
////        case .symptom:
////            self.symptoms = symptoms
////        case .photo:
////            self.photo = photo
////            
////        }
//    }
//    
//    
//    
//    //
//    
    

enum PostType {
    
    case symptom, temp, painLevel, note, photo
    
}
