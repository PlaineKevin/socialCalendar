//
//  FriendTableViewCell.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImage.layer.cornerRadius = userImage.bounds.width / 2.0
    }

}
