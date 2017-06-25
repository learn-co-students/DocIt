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
    
    // MARK: - Instances
    var user = Person(id: "", familyId: "", email: "")
    var family = Family(id: "", name: "", coverImage: nil, coverImageStr: "", members: [])
    var member = Member(profileImage: "", firstName: "", lastName: "", gender: "", birthday: "", bloodType: "", height: "", weight: "", allergies: "", id: "")
    var event = Event(name: "", startDate: "", uniqueID: "")
    var buttonEvent = ""
    
    // MARK: - Measurement system
    var isMetric = false
    
    // MARK: - Picker values
    var bloodTypeSelections: [String] = [BloodType.ABNeg.rawValue, BloodType.ABPos.rawValue, BloodType.ANeg.rawValue, BloodType.APos.rawValue, BloodType.BNeg.rawValue, BloodType.BPos.rawValue, BloodType.ONeg.rawValue, BloodType.OPos.rawValue]
    var genderSelections: [String] = [Gender.female.rawValue, Gender.male.rawValue, Gender.other.rawValue]
    
    // Imperial System
    
    // Temp
    var tempsInF: [String] = ["96.6", "96.8", "97.0", "97.2", "97.4", "97.6", "97.8", "98.0", "98.2", "98.4", "98.6", "98.8", "99.0", "99.2", "99.4", "99.6", "99.8", "100.0", "100.2", "100.4", "100.6", "100.8", "101.0", "101.2", "101.4", "101.6", "101.8", "102.0", "102.2", "102.4", "102.6", "102.8", "103.0", "103.2", "103.4", "103.6", "103.8", "104.0", "104.2", "104.6", "104.8", "105.0"]
    
    // Height
    var heightsInFeet : [String] = ["0\"","1\"","2\"","3\"","4\"","5\"","6\"", "7\"","8\"","9\"","11\""]
    var heightsInInches : [String] = ["0'","1'","2'","3'","4'","5'","6'", "7'","8'","9'"]
    
    // Weight
    var weightsInLbs: [String] = []
    
    func fillWeightDataInLbs() {
        for i in 1...300 {
            weightsInLbs.append("\(i) LB")
        }
    }
    
    // Metric System
    // Temp
    var tempsInC: [String] = ["35.0", "35.2", "35.4", "35.6", "35.8", "36.0", "36.2", "36.4", "36.6", "36.8", "37.0", "37.2", "37.4", "37.6", "37.8", "38.0", "38.2", "38.4", "38.6", "38.8", "39.0", "39.2", "39.4", "39.6", "39.8", "40.0"]
    
    // Height
    var heightsInMeter: [String] = [" - ", "1 m", "2 m"]
    var heightsInCm: [String] = []
    
    func fillHeightDataInCm() {
        for i in 0...99 {
            heightsInCm.append("\(i) cm")
        }
    }
    
    // Weight
    var weightsInKg: [String] = []
    var weightsInG: [String] = []
    
    func fillWeightDataInKg() {
        for i in 0...300 {
            weightsInKg.append("\(i)")
        }
    }
    
    func fillWeightDataInG(){
        for i in 0...9 {
            weightsInG.append("\(i)")
        }
    }
    
    var eventID = ""
    var editingEvent: Bool = false
    var postID = ""
    var imagePostID = ""
    var inviteFamilyID = ""
    
    // METHODS
    
    func clearDataStore() {
        eventID = ""
        postID = ""
        imagePostID = ""
    }
}
