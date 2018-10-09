//
//  ProfileViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/10/8.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchUser() {
        
    }
    
    func fetchMyPosts() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
