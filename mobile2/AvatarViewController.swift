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
    
    var refreshControl = UIRefreshControl()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        ProgressHUD.show("Loading...")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(shows), userInfo: nil, repeats: false)
    }
    
    func getData() {
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
