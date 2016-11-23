//
//  AddNotesViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddNotesViewController: UIViewController {
    
    var notes: String?
    
    @IBOutlet weak var addNotesTextField: UITextField!
    
    // Reference to database
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    // Reference to Post
    var postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("posts")
    //Reference to storage
    let storage : FIRStorage = FIRStorage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNotes(_ sender: UIButton) {
        guard let note = addNotesTextField.text, note != "" else { return }
        let databasePostRef = database.child("posts").child(Logics.sharedInstance.eventID).childByAutoId()
        let uniqueID = databasePostRef.key
        let post = Post(note: note)
        databasePostRef.setValue(post.serialize(), withCompletionBlock: {error, FIRDatabaseReference in
            self.dismiss(animated: true, completion: nil)
            
        })
        
        
        
    }
    //Tanira: Keyboard was not responding uncomment for last resort solution.
    //    func displayKeyboard(){
    //        self.addNotesTextField.becomeFirstResponder()
    //        self.dismiss(animated: true, completion: nil)
    //    }
    @IBAction func cancel(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    }
    
    
    
}




