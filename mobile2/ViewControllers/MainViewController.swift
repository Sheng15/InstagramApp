//
//  MainViewController.swift
//  mobile2
//
//  Created by Tianhang ZHANG on 5/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var postsTableView: UITableView!
    
    //    var posts = NSMutableArray()
    var posts = [Post]()
    var following = [String]()
    
    var likelistTony = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        ProgressHUD.show("Loading...")
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(shows), userInfo: nil, repeats: false)
    }

    // MARK: - Table view data source
    
    @objc func shows() {
        ProgressHUD.showSuccess()
    }
    
    func loadData(){
        
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String : AnyObject]
            for (_, value) in users{
                if let uid = value["uid"] as? String{
                    if uid == Auth.auth().currentUser?.uid{
                        if let followingUsers = value["following"] as? [String : String]{
                            for (_,user) in followingUsers{
                                self.following.append(user)
                            }
                        }
                        self.following.append(Auth.auth().currentUser!.uid)
                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            let postsSnap = snap.value as! [String: AnyObject]
                            for(_,post) in postsSnap{
                                if let userID = post["userID"] as? String{
                                    for each in self.following{
                                        if each == userID{
                                            let posttt = Post()
                                            if let author = post["author"] as? String, let likes = post["likes"] as? Int, let photoUrl = post["photoUrl"] as? String, let postID = post["postID"] as? String, let text = post["text"] as? String{
                                                posttt.author = author
                                                posttt.likes = likes
                                                posttt.photoUrl = photoUrl
                                                posttt.text = text
                                                posttt.userID = userID
                                                posttt.postID = postID
                                              
                                                if let people = post["peopleWhoLike"] as? [String : AnyObject]{
                                                    for (_,person) in people {
                                                        posttt.peopleWhoLike.append(person as! String)
                                                    }
                                                }
                                               
                                                self.posts.append(posttt)
                                               
                                            }
                                        }
                                    }
                                    self.postsTableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })
        ref.removeAllObservers()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        // creating the cell...
        cell.postImageView.getProfileImage(from: self.posts[indexPath.row].photoUrl)
        cell.titleLabel.text = self.posts[indexPath.row].author
        cell.likeLabel.text = "\(self.posts[indexPath.row].likes!) likes"
        cell.contentTextView.text = self.posts[indexPath.row].text
        cell.postID = self.posts[indexPath.row].postID
        cell.likeListTextView.text = ""
        
        for value in self.posts[indexPath.row].peopleWhoLike{
            let uidd = value 
            let ref = Database.database().reference()

            ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
                let users = snapshot.value as! [String: AnyObject]
                for(_,value) in users {
                    if let uid = value["uid"] as? String{
                        if uid==uidd{
                            let peopleLike = value["username"] as? String
                            self.likelistTony.append(peopleLike!)
                            let unique = Array(Set(self.likelistTony))
                          
                            if unique != []{
                                let showLikeList = unique.joined(separator: ", ")
                                
                                cell.likeListTextView.text = "liked by "+showLikeList
                                
                               
                            }
                        }
                    }
                }
                
            })
        }


      
        
        for person in self.posts[indexPath.row].peopleWhoLike{
            if person == Auth.auth().currentUser?.uid{
                cell.likeBtn.isHidden = true
                cell.unlikeBtn.isHidden = false
                break
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
