//
//  FollowingViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/10/21.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class FollowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        overviewUsers()
    }
    
    func overviewUsers() {
        
        let ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(currentUserID!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                self.user.removeAll()
                for (_, ouid) in following {
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                        
                        let users = snapshot.value as! [String: AnyObject]
                        
                        for (_, value) in users {
                            if let uid = value["uid"] as? String {
                                if uid == ouid as? String {
                                    let otherUsers = User()
                                    if let accName = value["username"] as? String, let profileUrl = value["profile_image"] as? String {
                                        otherUsers.accName = accName
                                        otherUsers.profileUrl = profileUrl
                                        otherUsers.userID = uid
                                        self.user.append(otherUsers)
                                    }
                                }
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
        })
        ref.removeAllObservers()
        ProgressHUD.showSuccess()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].accName
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.getProfileImage(from: self.user[indexPath.row].profileUrl!)
        checkFollowing(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isfollower = false
        
        ref.child("users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String: AnyObject] {
                for (k, value) in following {
                    if value as? String == self.user[indexPath.row].userID {
                        isfollower = true
                        
                        ref.child("users").child(uid!).child("following/\(k)").removeValue()
                        ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(k)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                    
                }
            }
            if !isfollower {
                let following = ["following/\(String(describing: key))" : self.user[indexPath.row].userID]
                let followers = ["followers/\(String(describing: key))" : uid]
                
                ref.child("users").child(uid!).updateChildValues(following as [AnyHashable : Any])
                ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers as [AnyHashable : Any])
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        ref.removeAllObservers()
    }
    
    @IBAction func Back(_ sender: Any) {
        
        let avt = self.storyboard?.instantiateViewController(withIdentifier: "h1") as! UITabBarController
        avt.selectedIndex = 4
        self.present(avt, animated: true, completion: nil)
    }
    
    func checkFollowing(indexPath: IndexPath) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == self.user[indexPath.row].userID {
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        ref.removeAllObservers()
        
    }
    
}
