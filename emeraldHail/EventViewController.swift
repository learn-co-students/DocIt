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


    // MARK: - Outlets

    @IBOutlet weak var addEventButton: UIBarButtonItem!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addEvent: UIView!

    // MARK: - Properties

    var store = DataStore.sharedInstance
    var events = [Event]()
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var memberID = ""
    var member = [Member]()
    let notificationCenter = NotificationCenter.default
    var navigationBarAppearace = UINavigationBar.appearance()

    // MARK: - Loads

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.delegate = self
        eventsTable.dataSource = self
        hideKeyboardWhenTappedAround()
        configDatabase()
        self.eventsTable.separatorStyle = .none
        eventsTable.reloadData()
        showPictureAndName()
        
        self.title = "Events"
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configDatabase()
        self.eventsTable.reloadData()
    }

    // MARK: - Actions

    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        store.buttonEvent = "Create Event"
        performSegue(withIdentifier: "addEvent", sender: nil)

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

        store.eventID = event.uniqueID

        if profileImageView.bounds.origin.y < 0 {

            self.title = store.member.firstName
        }





        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.eventID = events[indexPath.row].uniqueID
        store.event.name = events[indexPath.row].name


    }


    // MARK: - Methods

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let databaseEvents = self.database.child(Constants.Database.events).child(store.member.id)
        let uniqueEventID = events[indexPath.row].uniqueID

        let databasePosts = self.database.child(Constants.Database.posts).child(uniqueEventID)

        var posts = [Post]()
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            print("********** The delete button is tapped ********** ")

            // Alert Controller

             let alertController = UIAlertController(title: "Are you sure you want to delete this event?",  message: "All associated posts will be deleted.", preferredStyle: .alert)

            // Action

            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in

                print("********** User confimed to delete the event ********** ")

                // delete item at indexPath

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
                        self.deleteImagesFromStorage(uniqueID: post.description)
                    }

                    databasePosts.removeValue()

                })

                self.events.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in

                print("Cancel Pressed")

            })

            // Add the actions
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)

            // Present the controller
            self.present(alertController, animated: true, completion: nil)

        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath

            self.store.eventID = self.events[indexPath.row].uniqueID

            self.store.event.name = self.events[indexPath.row].name
            self.store.event.startDate = self.events[indexPath.row].startDate

            self.store.buttonEvent = "Modify Event"

            self.performSegue(withIdentifier: "addEvent", sender: nil)

        }

        edit.backgroundColor = Constants.Colors.neonCarrot

        return [delete, edit]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


        switch sender {
        case is UITableViewCell:
            guard let indexPath = eventsTable.indexPath(for: sender as! UITableViewCell) else { return }
            print(events[indexPath.row].uniqueID)
                        store.eventID = events[indexPath.row].uniqueID

        default:
            break
        }
    }

    // MARK: - Methods

    func deleteImagesFromStorage(uniqueID: String){

        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        let storageImageRef = storageRef.child(Constants.Storage.postsImages).child(uniqueID)

        storageImageRef.delete(completion: { error -> Void in

            if error != nil {
                print("Error occured while deleting imgs from Firebase storage")
            } else {
                print("Image removed from Firebase successfully!")
            }

        })

    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboardView() {
        view.endEditing(true)
    }

    func showPictureAndName() {

        let member = FIRDatabase.database().reference().child(Constants.Database.members).child(store.user.familyId).child(store.member.id)
        
        member.observe(.value, with: { snapshot in
            var member = snapshot.value as? [String : Any]
            let name = member?["firstName"] as? String
            let imageString = member?["profileImage"] as? String
            guard let imgUrl = imageString else {return}
            let profileImgUrl = URL(string: imgUrl)
            self.profileImageView.sd_setImage(with: profileImgUrl)
            self.profileImageView.setRounded()
            self.profileImageView.contentMode = .scaleAspectFill
            self.nameLabel.text = name
        })
    }


    func configDatabase() {

        let memberID: String = store.member.id

        let eventsRef = FIRDatabase.database().reference().child(Constants.Database.events).child(memberID)

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

}

class EventTableViewCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!

}
