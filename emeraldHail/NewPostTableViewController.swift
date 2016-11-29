//
//  NewPostTableViewController.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachPost = posts[indexPath.row]
        
        switch eachPost {
            
        case .note(let notePost):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
            
            print("We have a note.")
            
            let temporary = Post(
            
            cell.noteView.post = eachPost
        
            return cell

//        case .temp(let tempPost):
//            
//            
//            // TODO: Change this to temp cell after creating it
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NoteCell
//            
//            print("We have a temp.")
//            
//            cell.noteView.post = tempPost
//            
//            return cell
            
            
            
        }
        
    }

}
