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
    @IBOutlet weak var plusButton: UIButton!

    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Event.configureDatabase(database: Database.events , memberId: Store.member.id, tableView: eventsTable)
        self.eventsTable.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func addEvent(_ sender: UIButton) {
        Store.buttonEvent = "Create Event"
        performSegue(withIdentifier: "addEvent", sender: nil)
        
    }
    
    // MARK: TableView Methods
    func setupView() {
        eventsTable.delegate = self
        eventsTable.dataSource = self
        title = "Events"
        hideKeyboardWhenTappedAround()
        Event.configureDatabase(database: Database.events , memberId: Store.member.id, tableView: eventsTable)
        plusButton.shadow()
        eventsTable.separatorStyle = .none
        eventsTable.reloadData()
        Event.showEventHeaderPictureAndName(
            database: Database.members,
            familyId: Store.user.familyId,
            memberId: Store.member.id,
            nameLabel: nameLabel,
            profileImage: profileImageView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        let event = Store.events[indexPath.row]
        cell.eventName.text = event.name
        cell.eventDate.text = event.startDate.uppercased()
        Store.eventID = event.uniqueID
        if profileImageView.bounds.origin.y < 0 {
            self.title = Store.member.firstName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Store.eventID = Store.events[indexPath.row].uniqueID
        Store.event.name = Store.events[indexPath.row].name
    }
    
    // MARK: - Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return Event.deleteOrEditEvent(
            databaseEvent: Database.events,
            databasePost: Database.posts,
            member: Store.member.id,
            tableView: tableView,
            indexPath: indexPath,
            controller: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch sender {
        case is UITableViewCell:
            guard let indexPath = eventsTable.indexPath(for: sender as! UITableViewCell) else { return }
            Store.eventID = Store.events[indexPath.row].uniqueID
        default:
            break
        }
    }
    
    // MARK: - Methods
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
}

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
}
