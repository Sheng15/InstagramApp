//
//  AvatarViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/9/23.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class AvatarViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accname: UILabel!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    
    @IBOutlet weak var showfollowing: UIStackView!
    @IBOutlet weak var showfollower: UIStackView!
    var postList: Array<Any>!
    var post = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.dataSource = self
        getData()
        getMyPost()
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.Showfollowing))
        showfollowing.addGestureRecognizer(tapGesture1)
        showfollowing.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.Showfollower))
        showfollower.addGestureRecognizer(tapGesture2)
        showfollower.isUserInteractionEnabled = true
        
        profileImage.layer.cornerRadius = 58
        profileImage.clipsToBounds = true
        ProgressHUD.show("Loading...")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(shows), userInfo: nil, repeats: false)
    }
    
    @objc func shows() {
        ProgressHUD.showSuccess()
    }
    
    @objc func Showfollowing(){
        let avt = self.storyboard?.instantiateViewController(withIdentifier: "fg")
        self.present(avt!, animated: true, completion: nil)
    }
    
    @objc func Showfollower(){
        let avt = self.storyboard?.instantiateViewController(withIdentifier: "fr")
        self.present(avt!, animated: true, completion: nil)
    }
    func getData() {
        self.postList = []
        let currentUserID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.childrenCount == 0 {
                return
            }
            let users = snapshot.value as! [String: AnyObject]
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == currentUserID {
                        if let accName = value["username"] as? String, let profileUrl = value["profile_image"] as? String {
                            self.accname.text = accName
                            let url = URLRequest(url: URL(string: profileUrl)!)
                            
                            let event = URLSession.shared.dataTask(with: url) {
                                (data, response, error) in
                                
                                if error != nil {
                                    ProgressHUD.showError(error?.localizedDescription)
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    self.profileImage.image = UIImage(data: data!)
                                }
                            }
                            event.resume()
                            break
                        }
                    }
                }
            }
        })
        let ref2 = Database.database().reference().child("users").child(currentUserID!).child("following")
        let ref3 = Database.database().reference().child("users").child(currentUserID!).child("followers")
        let ref4 = Database.database().reference().child("posts")
        ref2.observe(.value, with: { (snapshot: DataSnapshot!) in
            print(snapshot.childrenCount)
            self.following.text = String(snapshot.childrenCount)
            
        })
        ref3.observe(.value, with: { (snapshot: DataSnapshot!) in
            print(snapshot.childrenCount)
            self.follower.text = String(snapshot.childrenCount)
            
        })
        ref4.observe(.value, with: { (snapshot: DataSnapshot!) in
            if let uniqid = snapshot.value as? [String: AnyObject] {
                for (k, value) in uniqid {
                    if value["userID"] as? String == currentUserID {
                        self.postList.append(k)
                    }
                }
            }
            self.posts.text = String((self.postList).count)
        })
        self.postList = []
        ref.removeAllObservers()
    }
    @IBAction func LGBT(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let LOerror {
            print(LOerror)
        }
        
        let ssb = self.storyboard?.instantiateViewController(withIdentifier: "ss")
        self.present(ssb!, animated: true, completion: nil)
    }
    
    func getMyPost() {
        
        let ref = Database.database().reference()
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.childrenCount == 0 {
                print(snapshot.childrenCount)
                return
            }
            
            let posts = snapshot.value as! [String: AnyObject]
            self.post.removeAll()
            for (_, value) in posts {
                if let uid = value["userID"] as? String {
                    if uid == currentUserID {
                        let mp = Post()
                        if let url = value["photoUrl"] as? String {
                            mp.photoUrl = url
                            self.post.append(mp)
                        }
                    }
                }
            }
            self.collection.reloadData()
        })
        ref.removeAllObservers()
        ProgressHUD.showSuccess()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Postcell", for: indexPath) as! PostCell
        cell.PostView.getProfileImage(from: self.post[indexPath.row].photoUrl!)
        
        return cell
    }
    
}

