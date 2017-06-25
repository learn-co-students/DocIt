//
//  Event.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Event {
    
    var name: String
    var startDate: String
    var isComplete: Bool = false
    var uniqueID: String
    
    init(name: String, startDate: String, uniqueID: String = "") {
        self.name = name
        self.startDate = startDate
        self.uniqueID = uniqueID
    }
    
    init(dictionary: [String : Any], uniqueID: String) {
        name = dictionary["name"] as? String ?? "No name"
        startDate = dictionary["startDate"] as? String ?? "No start date"
        self.uniqueID = uniqueID
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        name = snapshotValue["name"] as! String
        startDate = snapshotValue["startDate"] as! String
        uniqueID = snapshotValue["uniqueID"] as! String
    }
    
    func serialize() -> [String : Any] {
        return  ["name" : name, "startDate": startDate, "isComplete" : isComplete, "uniqueID": uniqueID]
    }
}

// Used to sort events
extension Event: Hashable {
    
    var hashValue: Int {
        return uniqueID.hash
    }
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.uniqueID == rhs.uniqueID
    }
}

extension Event {

    static func saveEvent(button: UIButton,
                          eventViewTitle: UILabel,
                          nameTextField: UITextField?,
                          dateTextField: UITextField?,
                          controller: UIViewController) {
        button.isEnabled = false
        if eventViewTitle.text == "Create Event" {
            guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
            let databaseEventsRef = Database.events.child(Store.member.id).childByAutoId()
            let uniqueID = databaseEventsRef.key
            let event = Event(name: name, startDate: date, uniqueID: uniqueID)
            databaseEventsRef.setValue(event.serialize(), withCompletionBlock: { error, dataRef in
                guard let nameTextField = nameTextField, let dateTextField = dateTextField else { return }
                nameTextField.text = ""
                dateTextField.text = ""
            })
        } else {
            guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
            let databaseEventsRef = Database.events.child(Store.member.id).child(Store.eventID)
            let uniqueID = databaseEventsRef.key
            let event = Event(name: name, startDate: date, uniqueID: uniqueID)
            databaseEventsRef.updateChildValues(event.serialize(), withCompletionBlock: { error, dataRef in
                // TODO: Handle error
            })
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
