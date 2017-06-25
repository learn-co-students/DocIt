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

    static func configureDatabase(database: FIRDatabaseReference, memberId: String, tableView: UITableView) {
        let eventsRef = database.child(memberId)
        eventsRef.observe(.value, with: { snapshot in
            Store.events = []
            for event in snapshot.children {
                let newEvent = Event(snapshot: event as! FIRDataSnapshot)
                Store.events.insert(newEvent, at: 0)
            }
            tableView.reloadData()
        })
    }

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

    static func showEventHeaderPictureAndName(database: FIRDatabaseReference,
                                              familyId: String,
                                              memberId: String,
                                              nameLabel: UILabel,
                                              profileImage: UIImageView) {
        let member = database
            .child(familyId)
            .child(memberId)
        member.observe(.value, with: { snapshot in
            var member = snapshot.value as? [String : Any]
            nameLabel.text = member?["firstName"] as? String
            guard let image = member?["profileImage"] as? String else { return }
            let imageURL = URL(string: image)
            profileImage.sd_setImage(with: imageURL)
            profileImage.setRounded()
            profileImage.contentMode = .scaleAspectFill
        })
    }

    static func deleteOrEditEvent(databaseEvent: FIRDatabaseReference,
                            databasePost: FIRDatabaseReference,
                            member: String,
                            tableView: UITableView,
                            indexPath: IndexPath,
                            controller: UIViewController) -> [UITableViewRowAction]? {
        let databaseEvents = databaseEvent.child(member)
        let uniqueEventID = Store.events[indexPath.row].uniqueID
        let databasePosts = databasePost.child(uniqueEventID)
        var posts = [Post]()
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // Alert Controller
            let alertController = UIAlertController(title: "Are you sure you want to delete this event?",
                                                    message: "All associated posts will be deleted.",
                                                    preferredStyle: .alert)
            // Action
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
                // Delete item at indexPath
                // Deleting selected events and related posts from Firebase
                databaseEvents.child(uniqueEventID).removeValue()
                databasePosts.observeSingleEvent(of: .value, with: { snapshot in
                    let oldPosts = snapshot.value as? [String: Any]
                    let allKeys = oldPosts?.keys
                    guard let keys = allKeys else { return }
                    for key in keys {
                        let dictionary = oldPosts?[key] as? [String: Any]
                        let post = Post(dictionary: dictionary!)
                        posts.append(post)
                    }
                    for post in posts {
                        deleteImagesFromStorage(uniqueID: post.description)
                    }
                    databasePosts.removeValue()
                })
                Store.events.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                print("Cancel Pressed")
            })

            // Add the actions
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)

            // Present the controller
            controller.present(alertController, animated: true, completion: nil)
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            Store.eventID = Store.events[indexPath.row].uniqueID
            Store.event.name = Store.events[indexPath.row].name
            Store.event.startDate = Store.events[indexPath.row].startDate
            Store.buttonEvent = "Modify Event"
            controller.performSegue(withIdentifier: "addEvent", sender: nil)
        }
        edit.backgroundColor = Constants.Colors.neonCarrot
        return [delete, edit]
    }

    static func deleteImagesFromStorage(uniqueID: String) {
        let storageImageRef = Database.storagePosts.child(uniqueID)
        storageImageRef.delete(completion: { error -> Void in
            guard let error = error else {
                return print("Image removed from Firebase successfully!")
            }
            print(error.localizedDescription)
        })
    }
}
