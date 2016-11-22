//
//  EventViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTable: UITableView!
    
    var events = [Event]()
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var memberID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        configDatabase()
        eventsTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configDatabase()
        self.eventsTable.reloadData()
    }
    
    @IBAction func members(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        
        var nameTextField: UITextField?
        var dateTextField: UITextField?
        let alertController = UIAlertController(title: "Create event", message: "Put a name that describe the event and the date when started", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            
            var name = nameTextField?.text
            var date = dateTextField?.text
            
            let databaseEventsRef = self.database.child("events").child(EventLogics.sharedInstance.memberID).childByAutoId()
            
            
            let uniqueID = databaseEventsRef.key
            
            let event = Event(name: name!, startDate: date!)
            
            databaseEventsRef.setValue(event.serialize(), withCompletionBlock: { error, dataRef in
                
            })
            
            self.eventsTable.reloadData()

            print("Save Button Pressed")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        
            print("Cancel Button Pressed")
        }
        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            nameTextField = textField
            nameTextField?.placeholder = "Event name"
        }
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            dateTextField = textField
            dateTextField?.placeholder = "Date"
        }
        
        present(alertController, animated: true, completion: nil)
        
           }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        cell.eventName.text = event.name
        cell.eventDate.text = event.startDate
        return cell
    }
    
    func configDatabase() {
        
        let memberID: String = EventLogics.sharedInstance.memberID
        
        let eventsRef = FIRDatabase.database().reference().child("events").child(memberID)
        
        eventsRef.observe(.value, with: { snapshot in
            
            var newEvents = [Event]()
        
            for event in snapshot.children {
                
                let newEvent = Event(snapshot: event as! FIRDataSnapshot)
                
                newEvents.append(newEvent)
                
            }
            
            self.events = newEvents
        
            self.eventsTable.reloadData()
        })
        
    }
}



class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
}

class EventLogics {
    
    private init() {}
    
    static let sharedInstance = EventLogics()
    
    var memberID = ""
    
}
 
