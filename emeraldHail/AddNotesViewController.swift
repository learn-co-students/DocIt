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
    var postVC = PostViewController()
    
    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        hideKeyboardWhenTappedAround()
        noteView.docItStyleView()
        saveButton.docItStyle()
        cancelButton.docItStyle()
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        addNotesTextView.delegate = self
        addNotesTextView.becomeFirstResponder()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        addNotesTextView.text = nil
    }
    
    @IBAction func addNotes(_ sender: UIButton) {
        Note.addNote(button: sender, noteTextView: addNotesTextView, timeStamp: getTimestamp(), controller: self)
        saveButton.isEnabled = false
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func textViewDidChange(_ textView: UITextView) {
        if addNotesTextView.text != "" {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Constants.Colors.scooter
        }
    }
}
