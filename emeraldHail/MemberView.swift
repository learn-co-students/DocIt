//
//  MemberView.swift
//  emeraldHail
//
//  Created by Mirim An on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

protocol ImageDelegate: class {
    
    func canDisplayImage(member: Member) -> Bool
    
}

class MemberView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    weak var delegate: ImageDelegate!
    
    var member: Member! {
        didSet {
            
            memberNameLabel.text = member.firstName
            
            if member.image == nil {
                
                if member.isDownloadingImage { return }
                
                // TODO: This member.profileImage ?? "" isn't right. We should instead look to see if this is nil, if so--instead we should set the image to equal a default image that's stored somewhere in firebase (or locally on the phone).
                
                member.downloadProfileImage(at: member.profileImage ?? "", handler: { success, image in
                    
                    DispatchQueue.main.async {
                        
                        guard success else { return }
                        
                        if self.delegate!.canDisplayImage(member: self.member) {
                            
                            UIView.transition(with: self.profileImageView, duration: 0.8, options: .transitionCrossDissolve, animations: { 
                                
                                self.profileImageView.image = image
                                
                            }, completion: nil)
                            
                        }
                        
                    }
                    
                })
                
            } else {
                
                profileImageView.image = member.image!
                
            }
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MemberView", owner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = 45.0
        profileImageView.layer.masksToBounds = true
    }
    
    
    
}
