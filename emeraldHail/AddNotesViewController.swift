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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
    
    // MARK: - Actions
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Methods
    
    func setupView() {
        
        view.backgroundColor = Constants.Colors.transBlack
        
        noteView.docItStyleView()
        
        saveButton.docItStyle()
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        
        cancelButton.docItStyle()
    
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addNotesTextView.text = nil
        
    }

    @IBAction func addNotes(_ sender: UIButton) {
        
        saveButton.isEnabled = false
        
        guard let noteText = addNotesTextView.text, noteText != "" else { return }
        
        let postsRef = database.child(Constants.Database.posts).child(store.eventID).childByAutoId()
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
    
    func textViewDidChange(_ textView: UITextView) {
        
        if addNotesTextView.text != "" {
            
            saveButton.isEnabled = true
            saveButton.backgroundColor = Constants.Colors.scooter
            
        }
        
    }
}
