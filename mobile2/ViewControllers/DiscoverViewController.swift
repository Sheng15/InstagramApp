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
    var selectUser = [User]()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    // collectionView UI
    var collectionView : UICollectionView!
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement search bar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        //call functions
        overviewUsers()
    }
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
    
    // clicked cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        overviewUsers()
    }
    
    // search updated
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let ref = Database.database().reference()
        let searchUserID = searchBar.text!
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String: AnyObject]
            self.selectUser.removeAll()
            for (_, value) in users {
                if let accName = value["username"] as? String {
                    if accName.lowercased().contains(searchUserID.lowercased()) {
                        let searchUsers = User()
                        if let uid = value["uid"] as? String, let profileUrl = value["profile_image"] as? String {
                            searchUsers.accName = accName
                            searchUsers.profileUrl = profileUrl
                            searchUsers.userID = uid
                            self.selectUser.append(searchUsers)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
        ProgressHUD.showSuccess()
        return true
    }
    
    //load suggest users
    func overviewUsers() {
        let ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser?.uid
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String: AnyObject]
            self.selectUser.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != currentUserID {
                        let otherUsers = User()
                        if let accName = value["username"] as? String, let profileUrl = value["profile_image"] as? String {
                            otherUsers.accName = accName
                            otherUsers.profileUrl = profileUrl
                            otherUsers.userID = uid
                            self.selectUser.append(otherUsers)
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
    // cell number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectUser.count
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
        cell.usernameLabel.text = self.selectUser[indexPath.row].accName
        cell.avaImg.getProfileImage(from: self.selectUser[indexPath.row].profileUrl!)
        return cell
    }
    
    // selected tableView cell - selected user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // calling cell again to call cell data
        let cell = tableView.cellForRow(at: indexPath) as! DiscoverCell
        
    }
    
}
