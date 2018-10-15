//
//  DiscoverViewController.swift
//  mobile2
//
//  Created by 赵子健 on 2018/10/15.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class DiscoverViewController: UITableViewController, UISearchBarDelegate {
    
    //declare search bar
    var searchBar = UISearchBar()
    
    //hold information from server
    var user = [User]()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewUsers()
        
        //implement search bar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
    }
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // hide collectionView when started search
        //collectionView.isHidden = true
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
    
    // clicked cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // unhide collectionView when tapped cancel button
        //collectionView.isHidden = false
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        //loadUsers()
    }
    
    //overview all users
    func overviewUsers() {
        let ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser?.uid
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String: AnyObject]
            self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != currentUserID {
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
        ref.removeAllObservers()
        ProgressHUD.showSuccess()
    }
    
    // TABLEVIEW CODE
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DiscoverCell
        
        // hide follow button
        cell.followButton.isHidden = true
        
        // connect cell's objects with received infromation from server
        cell.usernameLabel.text = self.user[indexPath.row].accName
        cell.avaImg.getProfileImage(from: self.user[indexPath.row].profileUrl!)
        return cell
    }
}
