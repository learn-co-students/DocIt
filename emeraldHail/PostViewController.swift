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


var postss = [Post]()

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var deletedPostRef: FIRDatabaseReference?
    var uniqueID: String?
    
    var posts = [Post]()
    var store = DataStore.sharedInstance
    let postsRef = FIRDatabase.database().reference().child("posts")
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽\nInside the PostVC\nfamilyID: \(store.family.id)\nmemberID: \(store.memberID)\neventID: \(store.eventID)\n👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽👌🏽")
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.separatorStyle = .none
        
        // Self-sizing Table View Cells
        // TODO: Maybe limit the size of the cell or number of characters. Then implement
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.estimatedRowHeight = 150
        
        fetchPosts()
        fetchMemberDetails()
        postTableView.reloadData()
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
        
        switch eachPost {
            
        case .note(let note):
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            noteCell.noteView.note = note
            noteCell.backgroundColor = UIColor.getRandomColor()
            return noteCell
        case .temp(let temp):
            let tempCell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath) as! TempCell
            tempCell.tempView.temp = temp
            tempCell.backgroundColor = UIColor.getRandomColor()
            return tempCell
        case .pain(let pain):
            let painCell = tableView.dequeueReusableCell(withIdentifier: "PainCell", for: indexPath) as! PainLevelCell
            painCell.painLevelView.pain = pain
            painCell.backgroundColor = UIColor.getRandomColor()
            return painCell
        case .symp(let symp):
            let sympCell = tableView.dequeueReusableCell(withIdentifier: "SympCell", for: indexPath) as! SymptomCell
            sympCell.symptomView.symp = symp
            sympCell.backgroundColor = UIColor.getRandomColor()
            return sympCell
        case .photo(let photo):
            let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            photoCell.PhotoView.photo = photo
            photoCell.backgroundColor = UIColor.getRandomColor()
            return photoCell
        default:
            fatalError("Can't create cell. Invalid post type found from the snapshot.")
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let databasePosts = postsRef.child(store.eventID)
        
        if editingStyle == .delete {
            
            // Deleting post data from Firebase using UniquePostID
            
            let uniquePostID = posts[indexPath.row].description

            store.postID = uniquePostID
            databasePosts.child(store.postID).removeValue()
//            databasePosts.child(store.imagePostID).removeValue()
            
            // Deleting images from storge
            
            let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
//            let storageImgRef = storageRef.child("postsImages").child(store.imagePostID)
            let storageImgRef = storageRef.child("postsImages").child(store.postID)
            
            storageImgRef.delete(completion: { error -> Void in
                
                if error != nil {
                    print("Error occured while deleting imgs from Firebase storage")
                } else {
                    print("Image removed from Firebase successfully!")
                }
                
            })
            
            // Deleting posts from tableviews
            
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Firebase
    func fetchPosts() {
        
        postsRef.child(store.eventID).observe(.value, with: { [unowned self] snapshot in
            
            DispatchQueue.main.async {
                // Guard to protect an empty dictionary (no posts yet)
                guard let value = snapshot.value as? [String : Any] else { return }
                
                // TODO: Clear the posts array so we do not append duplicates to the array. This is inefficient, so we should probably think about a better way to do this. Sets instead of Array?
                self.posts.removeAll()
                
                // allKeys is all of the keys returned from the snapshot
                let allKeys = value.keys
                
                // We look through all the keys
                for key in allKeys {
                    
                    // Inside each key os another dictionary from Firebase
                    let dictionary = value[key] as! [String : Any]
                    
                    // Create an instance of a Post with the dictionary
                    let post = Post(dictionary: dictionary)
                    
                    // Append to the posts array
                    self.posts.insert(post, at: 0)
                }
                
                // Sorting the posts in reverse chronological order
                let sortedPosts = self.posts.sorted(by: { (postOne, postTwo) -> Bool in
                    return postOne.timestamp > postTwo.timestamp
                })
                
                self.posts = sortedPosts
                postss = self.posts
                
                self.postTableView.reloadData()
            }
        })
        
    }
    
    func fetchMemberDetails() {
        let member = FIRDatabase.database().reference().child("members").child(store.family.id).child(store.memberID)
        
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
