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

    // Mark: Register
    
    
    
    // MARK: - Instances
    
    var user = Person(id: "", familyId: "", email: "")
    
    var family = Family(id: "", name: "", coverImage: nil, coverImageStr: "", members: [])

    var member = Member(profileImage: "", firstName: "", lastName: "", gender: "", birthday: "", bloodType: "", height: "", weight: "", allergies: "", id: "")
    
    var event = Event(name: "", startDate: "", uniqueID: "")
    
    
    // MARK: - Picker values
    
    var bloodTypeSelections : [String] = [BloodType.ABNeg.rawValue, BloodType.ABPos.rawValue, BloodType.ANeg.rawValue, BloodType.APos.rawValue, BloodType.BNeg.rawValue, BloodType.BPos.rawValue, BloodType.ONeg.rawValue, BloodType.OPos.rawValue]
    
    var genderSelections: [String] = [Gender.female.rawValue, Gender.male.rawValue, Gender.other.rawValue] 
    
    var heightSelections : [String] = ["0\"","1\"","2\"","3\"","4\"","5\"","6\"", "7\"","8\"","9\"","11\""]
    
    var heightSelectionsFeet : [String] = ["0'","1'","2'","3'","4'","5'","6'", "7'","8'","9'"]
    
    var weightSelections: [String] = []

    func fillWeightData() {
        
        for i in 1...300 {
            
            weightSelections.append("\(i) LB")
        }
        
    }

    var eventID = ""
    var editingEvent: Bool = false
    

    // POST

    var postID = ""
    
    // IMAGE POST
    
    var imagePostID = ""// this many be needed - please do not delete this comment - Luna :)

    // METHODS

    func clearDataStore() {

        eventID = ""
        postID = ""
        imagePostID = ""

        


    }

}
