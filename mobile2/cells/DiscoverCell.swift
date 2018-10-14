//
//  DiscoverCell.swift
//  mobile2
//
//  Created by 赵子健 on 2018/10/14.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit

class DiscoverCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: 10, y: 10, width: width / 5.3, height: width / 5.3)
        usernameLabel.frame = CGRect(x: avaImg.frame.size.width + 20, y: 28, width: width / 3.2, height: 30)
        followButton.frame = CGRect(x: width - width / 3.5 - 10, y: 30, width: width / 3.5, height: 30)
        followButton.layer.cornerRadius = followButton.frame.size.width / 20
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
}
