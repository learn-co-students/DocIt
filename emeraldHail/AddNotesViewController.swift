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

class AddNotesViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var addNotesTextView: UITextView!
    @IBOutlet weak var noteView: UIView!
    
    // MARK: - Properties
    
    let store = DataStore.sharedInstance
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var postVC = PostViewController()
    
    // MARK: - Loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        hideKeyboardWhenTappedAround()
        
        setupView()

        
        addNotesTextView.delegate = self
        addNotesTextView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func setupView() {
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)
        
        noteView.layer.cornerRadius = 10
        noteView.layer.borderColor = Constants.Colors.submarine.cgColor
        noteView.layer.borderWidth = 1
    
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addNotesTextView.text = nil
    }

    @IBAction func addNotes(_ sender: UIButton) {
        
        guard let noteText = addNotesTextView.text, noteText != "" else { return }
        
        let postsRef = database.child("posts").child(store.eventID).childByAutoId()
        let uniqueID = postsRef.key
        
        let newNote = Note(content: noteText, timestamp: getTimestamp(), uniqueID: uniqueID)
    
        
        postsRef.setValue(newNote.serialize(), withCompletionBlock: { error, ref in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
}
