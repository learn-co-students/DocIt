//
//  DataStore.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore{
    private init(){}
    static let sharedInstance = DataStore()
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "HealthCore")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // FAMILY
    
    var familyID = ""
    var familyName = ""
    var familyPicture = ""
    
    // MEMBER
    
    var memberID = ""
    var memberFirstName = ""
    var memberLastName = ""
    var memberGenderType = ""
    var memberDOB = ""
    var memberBloodType = ""
    var memberAllergies = ""
    
    // EVENT
    
    var eventID = ""
    
    // POST
    
    var postID = ""
    
    // METHODS
    
    func clearDataStore() {
        
        familyID = ""
        familyName = ""
        familyPicture = ""
        
        memberID = ""
        eventID = ""
        postID = ""
        memberGenderType = ""
        
    }

}


