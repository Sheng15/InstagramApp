//
//  PostTableViewCell.swift
//  mobile2
//
//  Created by Tianhang ZHANG on 5/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit
import  Firebase
import FirebaseDatabase

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
   
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    
    var postID: String!
    @IBAction func likeProcessed(_ sender: Any) {
        self.likeBtn.isEnabled = false
        let ref = Database.database().reference()
        let key2Post = ref.child("posts").childByAutoId().key
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject]{
                let updateLike: [String : Any] = ["peopleWhoLike/\(key2Post)":Auth.auth().currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLike, withCompletionBlock: { (error, reference) in
                    if error == nil{
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject]{
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject]{
                                    let count = likes.count
                                    self.likeLabel.text = "\(count) likes"
                                    
                                    let update = ["likes": count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtn.isHidden = true
                                    self.unlikeBtn.isHidden = false
                                    self.likeBtn.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
    }
    
    
    
    @IBAction func unlikeProcessed(_ sender: Any) {
        self.unlikeBtn.isEnabled = false
        let ref = Database.database().reference()
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject]{
                    for (id, person) in peopleWhoLike{
                        if person as? String == Auth.auth().currentUser!.uid{
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject]{
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject]{
                                                let count = likes.count
                                                self.likeLabel.text = "\(count) likes"
                                                let update = ["likes": count]

                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : update])
                                            }else{
                                                self.likeLabel.text = "0 likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : 0])

                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeBtn.isHidden = false
                            self.unlikeBtn.isHidden = true
                            self.unlikeBtn.isEnabled = true

                            break
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
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
