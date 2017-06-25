//
//  Family.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class Family {
    
    var id: String
    var name: String?
    var coverImage: UIImage?
    var coverImageStr: String?
    var members: [Member]?

    init(id: String) {
        self.id = id
    }
    
    // MARK: - Initializers
    init(id: String, name: String, coverImage: UIImage?, coverImageStr: String?, members: [Member]?) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
        self.coverImageStr = coverImageStr
        self.members = []
    }
    
    init(name: String, id: String = "") {
        self.name = name
        self.id = id
    }
    
    init(coverImageStr: String, id: String = "") {
        self.coverImageStr = coverImageStr
        self.id = id
        
    }
    
    func changeImage(to imageStr: String) {
        self.coverImageStr = imageStr
    }
    
    func serialize() -> [String:Any] {
        return ["name":name!, "coverImageStr": coverImageStr!]
    }
    
}

// MARK: - Update Functions
extension Family {

    static func saveNewFamilyName(newName: String?) {
        let store = DataStore.sharedInstance
        let database = Database.family.child(store.user.familyId)
        guard let newName = newName else { return }
        database.updateChildValues(["name": newName], withCompletionBlock: { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }

    func updateName(to name: String) {
        self.name = name
    }
    
    func updateCoverPhotoStr(to imageStr: String) {
        self.coverImageStr = imageStr
    }
    
}


// MARK: - Firebase Methods
extension Family {
    
    func getFamilyMetaData(handler: (Bool) -> Void) {
        downloadProfileImage { success, image in
            // TODO:
        }
    }
    
    func getMembersFromFamily(handler: (Bool) -> Void) {
        // TODO:
    }
    
}

// MARK: - Download Functions
extension Family {
    
    func downloadProfileImage(handler: (Bool, UIImage?) -> Void) {
        // TODO:
    }
    
}
