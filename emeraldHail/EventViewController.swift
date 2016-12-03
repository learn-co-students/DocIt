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
    
    
    // MARK: Outlets
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: Properties
    var store = DataStore.sharedInstance
    var events = [Event]()
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var memberID = ""
    var member = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.delegate = self
        eventsTable.dataSource = self
        hideKeyboardWhenTappedAround()
        configDatabase()
        self.eventsTable.separatorStyle = .none
        eventsTable.reloadData()
        showPictureAndName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configDatabase()
        self.eventsTable.reloadData()
    }
    
    // MARK: Actions
    @IBAction func addEvent(_ sender: Any) {
        createEvent()
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        let event = events[indexPath.row]
        cell.eventName.text = event.name
        cell.eventDate.text = event.startDate.uppercased()
        cell.backgroundColor = UIColor.getRandomColor()
        
        store.eventID =  event.uniqueID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.eventID = events[indexPath.row].uniqueID
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let databaseEvents = self.database.child("events").child(store.memberID)
        
        if editingStyle == .delete {
            
            // Deleting selected events from Firebase
            
            let uniqueEventID = events[indexPath.row].uniqueID
            databaseEvents.child(uniqueEventID).removeValue()
            
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Functions
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func showPictureAndName() {
        let member = FIRDatabase.database().reference().child("members").child(store.familyID).child(store.memberID)
        
        member.observe(.value, with: { snapshot in
            var member = snapshot.value as! [String : Any]
            let imageString = member["profileImage"] as! String
            let name = member["firstName"] as! String
            
            let profileImgUrl = URL(string: imageString)
            self.profileImageView.sd_setImage(with: profileImgUrl)
            self.profileImageView.setRounded()
            self.profileImageView.contentMode = .scaleAspectFill
            self.nameLabel.text = name
        })
    }
    
    
    func configDatabase() {
        
        let memberID: String = store.memberID
        let eventsRef = FIRDatabase.database().reference().child("events").child(memberID)
        
        eventsRef.observe(.value, with: { snapshot in
            
            var newEvents = [Event]()
            
            for event in snapshot.children {
                
                let newEvent = Event(snapshot: event as! FIRDataSnapshot)
                
                newEvents.insert(newEvent, at: 0)
        
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
            nameTextField?.autocapitalizationType = .words
            nameTextField?.placeholder = "Event name"
        }
        alertController.addTextField { (textField) -> Void in
            dateTextField = textField
            dateTextField?.autocapitalizationType = .words
            dateTextField?.placeholder = "Date"
        }
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UIColor {
    class func getRandomColor() -> UIColor {
        let red: CGFloat = CGFloat(drand48())
        let green: CGFloat = CGFloat(drand48())
        let blue: CGFloat = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.7)
    }
}

class EventTableViewCell: UITableViewCell {
    
    // OUTLETS
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
}

