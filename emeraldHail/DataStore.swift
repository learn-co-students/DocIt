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

    var family = Family(id: "", name: "", email: "", coverImage: nil, coverImageStr: "", members: [])
    
    var familyPicture = ""

    // MEMBER

    var member = Member(profileImage: "", firstName: "", lastName: "", gender: "", birthday: "", bloodType: "", height: "", weight: "", allergies: "", id: "")
    

    var bloodTypeSelections : [String] = [BloodType.ABNeg.rawValue, BloodType.ABPos.rawValue, BloodType.ANeg.rawValue, BloodType.APos.rawValue, BloodType.BNeg.rawValue, BloodType.BPos.rawValue, BloodType.ONeg.rawValue, BloodType.OPos.rawValue]
    
    var genderSelections: [String] = [Gender.female.rawValue, Gender.male.rawValue]
    
    var weightSelections: [String] = []

    func fillWeightData() {
        
        for i in 1...300 {
            
            weightSelections.append("\(i) LB")
        }
        
    }
    // EVENT

    var eventID = ""

    // POST

    var postID = ""
    
    // IMAGE POST
    
    var imagePostID = ""// this many be needed - please do not delete this comment - Luna :)

    // METHODS

    func clearDataStore() {


    //familyID = ""

        
        familyPicture = ""

        eventID = ""
        postID = ""
        imagePostID = ""

        


    }

}
