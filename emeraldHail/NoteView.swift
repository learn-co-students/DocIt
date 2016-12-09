//
//  NoteView.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/26/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var note: Note! {
        didSet {
            
            noteLabel.text = note.content
            timestampLabel.text = note.naturalTime
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("NoteView", owner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        
        timestampLabel.textColor = Constants.Colors.submarine
        
//        contentView.backgroundColor = UIColor.getRandomColor()
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        drawTimeline(circleColor: Constants.Colors.corn.cgColor, lineColor: Constants.Colors.submarine.cgColor)
    }
    
    
}
