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
    var store = Logics.sharedInstance
    let postsRef = FIRDatabase.database().reference().child("posts")
    var eventID = ""
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽\nInside the PostVC\nfamilyID: \(store.familyID)\nmemberID: \(store.memberID)\neventID: \(store.eventID)\n👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽")
        
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.separatorStyle = .none
        
        // Self-sizing Table View Cells
        // TODO: Maybe limit the size of the cell or number of characters. Then implement
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.estimatedRowHeight = 140
        
        
        fetchPosts()
        postTableView.reloadData()
//        hideKeyboardWhenTappedAround()
//        showPictureAndName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachPost = posts[indexPath.row]
        
        print("Switching on eachPost at \(indexPath.row)")
        
        switch eachPost {
            
        case .note(let note):
            
            print("We have a note post.")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            
            cell.noteView.note = note
            
            return cell

            
        case .temp(let temp):
            
            print("We have a temp post.")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath) as! TempCell
            
            cell.tempView.temp = temp
            
            return cell
            
        default:
            fatalError("Can't create cell.")
        }
        
    }
    
    // MARK: Functions
    func fetchPosts() {
        
        postsRef.child(store.eventID).observe(.value, with: { [unowned self] snapshot in
            
            DispatchQueue.main.async {
                
                // Guard to protect and empty dictionary (no posts yet)
                
                guard let value = snapshot.value as? [String : Any] else { return }
                
                
                let allKeys = value.keys
                
                // Clear posts
                self.posts = []
                
                for key in allKeys {
                    
                    let dictionary = value[key] as! [String : Any]
                    
                    let post = Post(dictionary: dictionary)
                    
                    self.posts.append(post)
                }
                self.postTableView.reloadData()
                
            }
        })
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
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
