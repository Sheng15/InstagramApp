//
//  DiscoverViewController.swift
//  mobile2
//
//  Created by 赵子健 on 2018/10/9.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UISearchBarDelegate {

    //declare search bar
    var searchBar = UISearchBar()
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement search bar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 30
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
