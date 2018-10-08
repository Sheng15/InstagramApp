//
//  EditViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/10/8.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit

class EditViewController: UITableViewController {

    @IBOutlet weak var usernnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        
    }
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        
    }
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        
    }
    
}
