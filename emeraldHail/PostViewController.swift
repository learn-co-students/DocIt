//
//  PostViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet var postButtons: [UIButton]! {
        didSet {
            postButtons.forEach {
                $0.isHidden = true
            }
        }
    }
    
    // MARK: Properties
    var posts = [Post]()
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var eventID = ""
    var store = Logics.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.separatorStyle = .none
        
        // Self-sizing Table View Cells
        // TODO: Maybe limit the size of the cell or number of characters. Then implement 
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.estimatedRowHeight = 140
        
        configDatabase()
        postTableView.reloadData()
        hideKeyboardWhenTappedAround()
        showPictureAndName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        configDatabase()
        
        postButtons.forEach {
            $0.isHidden = true
        }
        postTableView.reloadData()
    }
    
    
    // MARK: Actions
    @IBAction func addPost(_ sender: UIButton) {

        UIView.animate(withDuration: 0.3) {
            self.postButtons.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
    
    }
    
    // MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
//        let post = posts[indexPath.row]
//        
//        cell.noteLabel.text = post.note
//        cell.backgroundColor = UIColor.getRandomColor()
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        let eachPost = posts[indexPath.row]
        
        cell.noteView.post = eachPost
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: Functions
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }

    func createPost() {
        var noteTextField: UITextField?
        let alertController = UIAlertController(title: "Create post", message: "what's cracking?", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            let note = noteTextField?.text
            let databaseEventsRef = self.database.child("posts").child(Logics.sharedInstance.eventID).childByAutoId()
            let post = Post(note: note!)
            
            databaseEventsRef.setValue(post.serialize(), withCompletionBlock: { error, dataRef in
            })
            
            self.postTableView.reloadData()
            print("Save Button Pressed")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            noteTextField = textField
            noteTextField?.placeholder = "What just happened?"
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func configDatabase() {
        let eventID: String = store.eventID
        let postsRef = FIRDatabase.database().reference().child("posts").child(eventID)
        
        postsRef.observe(.value, with: { snapshot in
            var newPosts = [Post]()
            
            for post in snapshot.children {
                let newPost = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(newPost)
            }
            
            self.posts = newPosts
            self.postTableView.reloadData()
        })
    }
    
    func showPictureAndName() {
        let member = FIRDatabase.database().reference().child("members").child(store.familyID).child(store.memberID)
        
        member.observe(.value, with: { snapshot in
            var member = snapshot.value as! [String:Any]
            let imageString = member["profileImage"] as! String
            let name = member["firstName"] as! String
            let profileImgUrl = URL(string: imageString)
            
            self.profileImageView.sd_setImage(with: profileImgUrl)
            self.profileImageView.setRounded()
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.layer.borderColor = UIColor.gray.cgColor
            self.profileImageView.layer.borderWidth = 0.5
            self.nameLabel.text = name
        })
    }
    
}



class PostTableViewCell: UITableViewCell {
    
    // OUTLETS
    
    @IBOutlet weak var noteLabel: UILabel!
    
}
