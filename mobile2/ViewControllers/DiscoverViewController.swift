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
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
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
}
