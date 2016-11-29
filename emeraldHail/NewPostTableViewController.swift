//
//  NewPostTableViewController.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewPostTableViewController: UITableViewController {

    var posts = [Post]()
    var store = Logics.sharedInstance
    let postsRef = FIRDatabase.database().reference().child("posts")
    var eventID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventID = store.eventID
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachPost = posts[indexPath.row]
        
        switch eachPost {
            
        case .note(_):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            
            print("We have a note.")
            
            cell.noteView.post = eachPost
        
            return cell

        case .temp(_):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath) as! NoteCell
            
            print("We have a note.")
            
            cell.noteView.post = eachPost
            
            return cell
        }
        
    }
    
    
    func fetchPosts() {
        
//        postsRef.child(eventID).observe(.value, with: { snapshot in
//            var newPosts = [Post]()
//            
//            for item in snapshot.children {
//
//                
//            }
//            
//        })
    }

}
