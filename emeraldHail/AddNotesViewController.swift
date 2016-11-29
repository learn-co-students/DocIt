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
    
    // OUTLET
    
    @IBOutlet weak var addNotesTextField: UITextField!
    
    // PROPERTIES
    
    let store = Logics.sharedInstance
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("posts")
    let storage : FIRStorage = FIRStorage.storage()
    var notes: String?
    
    // LOADS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addNotesTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // ACTIONS
    
    @IBAction func addNotes(_ sender: UIButton) {
        guard let note = addNotesTextField.text, note != "" else { return }
        let databasePostRef = database.child("posts").child(store.eventID).childByAutoId()
        
        let timestamp = FIRServerValue.timestamp()
        
        let post = Post(eventID: store.eventID, timestamp: timestamp, postType: .note, postContent: note)
        databasePostRef.setValue(post.serialize(), withCompletionBlock: {error, FIRDatabaseReference in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // METHODS
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
}




