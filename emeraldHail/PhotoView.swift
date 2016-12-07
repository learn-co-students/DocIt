//
//  PhotoView.swift
//  emeraldHail
//
//  Created by Mirim An on 12/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class PhotoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var photo: Photo! {
        didSet {
            
            let photoUrl = URL(string: photo.content)
            photoImageView.sd_setImage(with: photoUrl)
            photoImageView.setCornerRounded()
            timestampLabel.text = photo.naturalTime
            
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
        Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)
        
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
        drawTimeline(circleColor: Constants.Colors.purpleCake.cgColor, lineColor: Constants.Colors.submarine.cgColor)
    }
    
    
}
