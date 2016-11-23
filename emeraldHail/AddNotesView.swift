//
//  AddNotesView.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase


class AddNotesView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Reference to database
    var database: FIRDatabaseReference = FIRDatabase.database().reference()
    // Reference to Post
    var postRef : FIRDatabaseReference = FIRDatabase.database().reference().child("Post")
    //Reference to storage 
    let storage : FIRStorage = FIRStorage.storage()
    
    
    @IBOutlet var AddNotesContentView: AddNotesView!
    @IBOutlet weak var inputAdditionalNotesTextField: UITextField!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit(){
//'Bundle.main.loadNibNamed("AddNotesView", owner: self, options: nil)
     //   self.addSubview(AddNotesContentView)
        Bundle.main.loadNibNamed("AddNotesView", owner: self, options: nil)
    }
    
    
    

    
    
    
    @IBAction func saveAdditionalNotesButton(_ sender: Any) {
        guard let note = inputAdditionalNotesTextField.text, note != "" else { return }
            let databasePostRef = database.child("Post").child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId()
            let uniqueID = databasePostRef.key
            let post = Post(note: note)
        databasePostRef.setValue(post.serialize(), withCompletionBlock: {error, FIRDatabaseReference in
        
           
        })
        
        
    }
    
    
    
    
    
    

}
