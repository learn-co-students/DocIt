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

    static func configDatabaseMember(database: FIRDatabaseReference, familyId: String, collectionView: UICollectionView) {
        let familyRef = database.child(familyId)
        familyRef.observe(.value, with: { snapshot in
            Store.members = []
            for item in snapshot.children {
                let newMember = Member(snapshot: item as! FIRDataSnapshot)
                Store.members.append(newMember)
            }
            collectionView.reloadData()
        })
    }

    static func configDatabaseFamily(database: FIRDatabaseReference, familyId: String) {
        let familyRef = database.child(familyId)
        familyRef.observe(.value, with: { snapshot in
            var dic = snapshot.value as? [String : Any]
            guard let familyName = dic?["name"] else { return }
            Store.family.name = familyName as? String
            guard let coverImgStr = dic?["coverImageStr"] else { return }
            Store.family.coverImageStr = coverImgStr as? String
        })
    }

    static func saveNewFamilyName(newName: String?) {
        let database = Database.family.child(Store.user.familyId)
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
