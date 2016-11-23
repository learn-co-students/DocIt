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
        Bundle.main.loadNibNamed("AddNotesView", owner: self, options: nil)
        self.addSubview(AddNotesContentView)
        
    }
    
    
    
    
    
    @IBAction func saveAdditionalNotesButton(_ sender: Any) {
        if inputAdditionalNotesTextField.text != "" {
            
        }
        
        
    }
    
    

}
