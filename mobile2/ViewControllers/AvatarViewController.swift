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

class AvatarViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accname: UILabel!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var follower: UILabel!
    
    var postList: Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        profileImage.layer.cornerRadius = 58
        profileImage.clipsToBounds = true
        ProgressHUD.show("Loading...")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(shows), userInfo: nil, repeats: false)
    }
    
    @objc func shows() {
        ProgressHUD.showSuccess()
    }
    
    func getData() {
        self.postList = []
        let currentUserID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
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
    
    
    
}
