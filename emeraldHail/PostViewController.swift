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
    
    var deletedPostRef: FIRDatabaseReference?
    
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
        print(posts.count)
        postTableView.reloadData()
        fetchMemberDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        postButtons.forEach {
            $0.isHidden = true
        }
        
        postTableView.reloadData()
    }
    
    
    // MARK: - Actions
    @IBAction func addPost(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.postButtons.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
    }
    
    // MARK: - TableView Methods
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
            
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            
            noteCell.noteView.note = note
            
            return noteCell
        
        case .temp(let temp):
            
            print("We have a temp post.")
            
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath) as! TempCell
            
            tempCell.tempView.temp = temp
            
            return tempCell
            
        case .pain(let pain):
            
            print("We have a pain post.")
            
            let painCell = tableView.dequeueReusableCell(withIdentifier: "PainCell", for: indexPath) as! PainLevelCell
            
            painCell.painLevelView.pain = pain
            
            return painCell
            
        case .photo(let photo):
            
            print("We have a photo post")
            
            let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            
            photoCell.PhotoView.photo = photo
            
            return photoCell
            
        default:
            fatalError("Can't create cell.")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    // MARK: - Firebase
    func fetchPosts() {
        
        postsRef.child(store.eventID).queryOrdered(byChild: "timestamp").observe(.value, with: { [unowned self] snapshot in
    
            print("⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️")
            dump(snapshot)
            
            DispatchQueue.main.async {
                // Guard to protect an empty dictionary (no posts yet)
                guard let value = snapshot.value as? [String : Any] else { return }
                
                // Clear the posts array so we do not append duplicates to the array. This is inefficient, so we should probably think about a better way to do this. Sets instead of Array?
                self.posts = []
                
                // allKeys is all of the keys returned from the snapshot
                let allKeys = value.keys
                
                // We look through all the keys
                for key in allKeys {
                    
                    // Inside each key os another dictionary from Firebase
                    let dictionary = value[key] as! [String : Any]
                    
                    // Create an instance of a Post with the dictionary
                    let post = Post(dictionary: dictionary)
                    
                    // Append to the posts array
                    self.posts.append(post)
                }
                
                // Debugging stuff
                print(self.posts.count)
                dump(self.posts)
                
                self.postTableView.reloadData()
            }
        })
        
    }
    
    func fetchMemberDetails() {
        let member = FIRDatabase.database().reference().child("members").child(store.familyID).child(store.memberID)
        
        member.observe(.value, with: { snapshot in
            var member = snapshot.value as! [String:Any]
            let imageString = member["profileImage"] as! String
            let name = member["firstName"] as! String
            let profileImgUrl = URL(string: imageString)
            
            self.profileImageView.sd_setImage(with: profileImgUrl)
            self.profileImageView.setRounded()
            self.profileImageView.contentMode = .scaleAspectFill
            self.nameLabel.text = name
        })
    }
    
}
