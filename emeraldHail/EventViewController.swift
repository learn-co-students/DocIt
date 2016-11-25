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
import SDWebImage

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // OUTLETS
    
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // PROPERTIES
    
    var store = Logics.sharedInstance
    var events = [Event]()
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var memberID = ""
    var member = [Member]()
    
    // LOADS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.delegate = self
        eventsTable.dataSource = self
        hideKeyboardWhenTappedAround()
        configDatabase()
        self.eventsTable.separatorStyle = .none
        eventsTable.reloadData()
        showPicture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configDatabase()
        self.eventsTable.reloadData()
    }
    
    // ACTIONS
    
    @IBAction func addEvent(_ sender: UIButton) {
        createEvent()
    }
    
    // TABLEVIEW METHODS
    
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
        
        
        Logics.sharedInstance.eventID =  event.uniqueID
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Logics.sharedInstance.eventID =  events[indexPath.row].uniqueID
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // METHODS
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func showPicture() {
        
        let member = FIRDatabase.database().reference().child("members").child(store.familyID).child(store.memberID)

        member.observe(.value, with: { snapshot in

            var image = snapshot.value as! [String:Any]
            let imageString = image["profileImage"] as! String
            
            let profileImgUrl = URL(string: imageString)
            self.profileImageView.sd_setImage(with: profileImgUrl)
            
            self.profileImageView.setRounded()
            self.profileImageView.layer.borderColor = UIColor.gray.cgColor
            self.profileImageView.layer.borderWidth = 0.5
            
            })
        }
    
    
    func configDatabase() {
        
        let memberID: String = Logics.sharedInstance.memberID
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
    
    func createEvent() {
        
        var nameTextField: UITextField?
        var dateTextField: UITextField?
        let alertController = UIAlertController(title: "Create event", message: "Put a name that describe the event and the date when started", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            
            guard let name = nameTextField?.text, name != "", let date = dateTextField?.text, date != "" else { return }
            
            
            let databaseEventsRef = self.database.child("events").child(self.store.memberID).childByAutoId()
            
            let uniqueID = databaseEventsRef.key
            
            let event = Event(name: name, startDate: date, uniqueID: uniqueID)
            
            databaseEventsRef.setValue(event.serialize(), withCompletionBlock: { error, dataRef in
                
            })
            
            print("Save Button Pressed")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
            print("Cancel Button Pressed")
        }
        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            
            nameTextField = textField
            nameTextField?.placeholder = "Event name"
        }
        alertController.addTextField { (textField) -> Void in
            
            dateTextField = textField
            dateTextField?.placeholder = "Date"
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

class EventTableViewCell: UITableViewCell {
    
    // OUTLETS
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
}

