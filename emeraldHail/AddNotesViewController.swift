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

    @IBOutlet weak var addNotesTextField: UITextField!

    let store = Logics.sharedInstance

    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    var postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("posts")

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addNotesTextField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    @IBAction func addNotes(_ sender: UIButton) {

        guard let noteText = addNotesTextField.text, noteText != "" else { return }

        let postsRef = database.child("posts").child(store.eventID).childByAutoId()
        let uniqueID = postsRef.key
        //let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss a"
        //let timestamp = dateFormatter.string(from: currentDate)

        let newNote = Note(content: noteText, timestamp: getTimestamp(), uniqueID: uniqueID)


        postsRef.setValue(newNote.serialize(), withCompletionBlock: { error, ref in
            self.dismiss(animated: true, completion: nil)
        })
    }

    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Functions
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboardView() {
        view.endEditing(true)
    }
}
