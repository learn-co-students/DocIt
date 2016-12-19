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
import Fusuma

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FusumaDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet var postButtons: [UIButton]! {
        didSet {
            postButtons.forEach {
                $0.isHidden = true
                $0.alpha = 0.0
            }
        }
    }
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Properties
    
    var deletedPostRef: FIRDatabaseReference?
    var uniqueID: String?
    var posts = [Post]()
    var store = DataStore.sharedInstance
    let postsRef = FIRDatabase.database().reference().child(Constants.Database.posts)
    
    var plusButtonIsRotated = false
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.separatorStyle = .none
        
        // Self-sizing Table View Cells
        // TODO: Maybe limit the size of the cell or number of characters. Then implement
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.estimatedRowHeight = 150
        
        self.title = self.store.event.name
        
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowRadius = 1.0
        plusButton.layer.shadowOpacity = 0.3
        
        self.postButtons.forEach {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            $0.layer.masksToBounds = false
            $0.layer.shadowRadius = 1.0
            $0.layer.shadowOpacity = 0.3
        }
        
        fetchPosts()
        fetchMemberDetails()
        postTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        postTableView.reloadData()
    }
    
    
    // MARK: - Actions
    
    @IBAction func addPost(_ sender: UIButton) {
        
        animatePostButtons()

    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        animatePostButtons()
        handleCameraImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animatePostButtons()
    }
    
    func animatePostButtons() {
        
        // usingSpringWithDamping: 0.1, initialSpringVelocity: 0.2,
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveLinear, animations: {
            
            if !self.plusButtonIsRotated {
                self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(45).degreesToRadians)
                
                self.postButtons.forEach {
                    $0.isHidden = false
                    $0.alpha = 1.0
                }
                
                self.plusButtonIsRotated = true
            } else {
                self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(0).degreesToRadians)
                
                self.postButtons.forEach {
                    $0.isHidden = true
                    $0.alpha = 0.0
                }
                
                self.plusButtonIsRotated = false
            }
            
            
        }, completion: nil)
        
    }
    
    // MARK: - Methods
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let databasePosts = postsRef.child(store.eventID)
        
        if editingStyle == .delete {
            
            // Deleting post data from Firebase using UniquePostID
            
            let uniquePostID = posts[indexPath.row].description
            
            store.postID = uniquePostID
            databasePosts.child(store.postID).removeValue()
            
            // databasePosts.child(store.imagePostID).removeValue()
            
            // Deleting images from storge
            
            let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
            //            let storageImgRef = storageRef.child("postsImages").child(store.imagePostID)
            
            let storageImgRef = storageRef.child(Constants.Storage.postsImages).child(store.postID)
            
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
    
    // MARK: Firebase
    
    func reloadTable() {
        postTableView.reloadData()
    }
    
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
                
                self.postTableView.reloadData()
            }
        })
        
    }
    
    func fetchMemberDetails() {
        
        let member = FIRDatabase.database().reference().child(Constants.Database.members).child(store.user.familyId).child(store.member.id)
        
        member.observe(.value, with: { snapshot in
            var member = snapshot.value as? [String:Any]
            let imageString = member?["profileImage"] as? String
            let name = member?["firstName"] as? String
            guard let imgString = imageString else{ return }
            let profileImgUrl = URL(string: imgString)
            self.profileImageView.sd_setImage(with: profileImgUrl)
            self.profileImageView.setRounded()
            self.profileImageView.contentMode = .scaleAspectFill
            self.nameLabel.text = name
        })
    }
    
    
    // MARK: Fusuma
    
    func handleCameraImage() {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion: nil)
        fusumaCropImage = true
        
    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    
    func fusumaImageSelected(_ image: UIImage) {
     
        uploadImageURLtoFirebaseDatabaseAndStorage(image)

        // present some alert with the image
        // add button to alert to send
        // upload from button
        
        print("Image selected")
        
    }
    
    // Return the image but called after is dismissed.
    
    func fusumaDismissedWithImage(_ image: UIImage) {
        
        // uploadImageURLtoFirebaseDatabaseAndStorage(image)
        
        activityIndicatorView.startAnimating()
        
        print("Called just after FusumaViewController is dismissed.")
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
        
    }
    
    // When camera roll is not authorized, this method is called.
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera access denied")
        
    }
    
    
    func uploadImageURLtoFirebaseDatabaseAndStorage(_ image: UIImage) {
        
        //guard let image = imageView.image, image != UIImage(named: "addImageIcon") else { return }
        
        // database
        
        let database: FIRDatabaseReference = FIRDatabase.database().reference()
        
        let databasePostsRef = database.child(Constants.Database.posts).child(store.eventID).childByAutoId()
        
        let uniqueID = databasePostsRef.key
        
        // storage
        
        let storageRef = FIRStorage.storage().reference(forURL: "gs://emerald-860cb.appspot.com")
        
        store.imagePostID = uniqueID
        
        let storageImageRef = storageRef.child(Constants.Storage.postsImages).child(store.imagePostID)
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.25) else { return }
        
        storageImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print (error?.localizedDescription ?? "Error occured while uploading img to Firebase" )
                return
            }
            
            guard let postImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            
            let photo = Photo(content: postImageUrl, timestamp: self.getTimestamp(), uniqueID: uniqueID)
            
            databasePostsRef.setValue(photo.serialize(), withCompletionBlock: { error, dataRef in
                // Disable the save button after it's pressed once
                
            })
            self.activityIndicatorView.stopAnimating()
        })
        

    }
    
}
