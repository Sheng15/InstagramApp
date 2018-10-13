//
//  PostTableViewCell.swift
//  mobile2
//
//  Created by Tianhang ZHANG on 5/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeListTextView: UITextView!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    var likelist = [String]()
    var postID: String!
    @IBAction func likeProcessed(_ sender: Any) {
        self.likeBtn.isEnabled = false
        let ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser?.uid
        let key2Post = ref.child("posts").childByAutoId().key
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value as? [String: AnyObject]) != nil{
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
                                    
                                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
                                        let users = snapshot.value as! [String: AnyObject]
                                        for(_,value) in users {
                                            if let uid = value["uid"] as? String{
                                                if uid == currentUserID{
                                                    let peopleLike = value["username"] as? String
                                                    self.likelist.append(peopleLike!)
                                                    print("这是赞")
                                                    print(self.likelist)
                                                    
                                                    let showLikeList = self.likelist.joined(separator: ", ")
                                                    
                                                    self.likeListTextView.text = "liked by "+showLikeList
                                                    
                                                }
                                            }
                                        }
                                        
                                    })
                                    
                                    
                                    
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
        let currentUserID = Auth.auth().currentUser?.uid
        
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
                                                
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : count])
                                                
                                                
                                                ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
                                                    let users = snapshot.value as! [String: AnyObject]
                                                    for(_,value) in users {
                                                        if let uid = value["uid"] as? String{
                                                            if uid == currentUserID{
                                                                let peopleLike = value["username"] as? String
                                                                while let idx = self.likelist.index(of: peopleLike!){
                                                                    self.likelist.remove(at: idx)
                                                                }
                                                                print("这是取消赞111")
                                                                print(self.likelist)
                                                                
                                                                let showLikeList = self.likelist.joined(separator: ", ")
                                                                
                                                                self.likeListTextView.text = "liked by "+showLikeList
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                                })
                                                
                                                
                                            }else{
                                                self.likeLabel.text = "0 likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : 0])
                                                ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
                                                    let users = snapshot.value as! [String: AnyObject]
                                                    for(_,value) in users {
                                                        if let uid = value["uid"] as? String{
                                                            if uid == currentUserID{
                                                                let peopleLike = value["username"] as? String
                                                                while let idx = self.likelist.index(of: peopleLike!){
                                                                    self.likelist.remove(at: idx)
                                                                }
                                                                print("这是取消赞222")
                                                                print(self.likelist)
                                                                
                                                                let showLikeList = self.likelist.joined(separator: ", ")
                                                                
                                                                self.likeListTextView.text = "liked by "+showLikeList
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                                })
                                                self.likeListTextView.text = ""
                                                
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
