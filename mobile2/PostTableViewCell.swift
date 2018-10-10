//
//  PostTableViewCell.swift
//  mobile2
//
//  Created by Tianhang ZHANG on 5/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
   
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBAction func likeProcessed(_ sender: Any) {
    }
    @IBAction func unlikeProcessed(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
