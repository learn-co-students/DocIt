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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configDatabase()
        self.eventsTable.reloadData()
    }

    // MARK: - Actions

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

        let databaseEvents = self.database.child("events").child(store.member.id)
        let uniqueEventID = events[indexPath.row].uniqueID

        let databasePosts = self.database.child("posts").child(uniqueEventID)

        var posts = [Post]()

        if editingStyle == .delete {

            // Deleting selected events and related posts from Firebase
            databaseEvents.child(uniqueEventID).removeValue()

            databasePosts.observeSingleEvent(of: .value, with: { snapshot in

                let oldPosts = snapshot.value as? [String : Any]
                
                let allKeys = oldPosts?.keys

                for key in allKeys! {

                    let dictionary = oldPosts?[key] as? [String : Any]

                    let post = Post(dictionary: dictionary!)

                    posts.append(post)

                    print(post.description)

                }

                for post in posts {

                    switch post {
                    case .photo(_):
                        self.deleteImagesFromStorage(uniqueID: post.description)
                    default:
                        break
                    }

                }

                databasePosts.removeValue()

            })

            events.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }


    // MARK: - Methods

    func deleteImagesFromStorage(uniqueID: String){

        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        let storageImageRef = storageRef.child("postsImages").child(uniqueID)

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
        let member = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.member.id)

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
        
        self.addEvent.isHidden = false
        
    }

}

class EventTableViewCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!

}
