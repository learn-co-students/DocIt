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

struct Post {

    var eventID: String
    var timestamp: TimeStamp
    var postType: PostType
    
    var postContent: String
    
//    init(eventID: String, timestamp: TimeStamp, postType: PostType) {
//        self.eventID = eventID
//        self.timestamp = timestamp
//        self.postType = postType
//    }

    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        eventID = snapshot.key
        timestamp = snapshotValue["timestamp"]
        postType = snapshotValue["postType"] as! String
        postContent = snapshotValue["note"] as! String
        
        
    }
    
    // MARK: - Firebase
    func serialize() -> [String : Any] {
        
        // Serialize the data to push to Firebase
        
        var dict: [String : Any] = [:]
        
        // use FIRServerValue.timestamp() when creating an instance of Post
        
        dict["timestamp"] = timestamp
        dict["postType"] = postType
        
        return dict
        
    }
    
    

    
    
}




enum PostType: String {
    case note, temp
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
