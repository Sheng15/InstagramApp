//
//  ProfileViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/10/12.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import ProgressHUD

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accName: UITextField!
    
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        getData()
        
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        ProgressHUD.show("Waiting")
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(shows), userInfo: nil, repeats: false)
        
    }
    
    @objc func shows() {
        ProgressHUD.showSuccess()
    }
    
    
    @IBAction func changBT(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.camera)
        }))
        
        //photo source - photo library
        actionSheet.addAction(UIAlertAction(title: "PHOTO LIBRARY", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.photoLibrary)
        }))
        
        //cancel button
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler:nil))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showImagePickerForSourceType(_ sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async(execute: {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .currentContext
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        
        self.profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBT(_ sender: Any) {
        updateData()
        
        let avt = self.storyboard?.instantiateViewController(withIdentifier: "h1") as! UITabBarController
        avt.selectedIndex = 0
        self.present(avt, animated: true, completion: ProgressHUD.showSuccess)
    }
    
    
    func updateData(){
        if let uid = Auth.auth().currentUser?.uid{
            let storageItem = storageRef.child("profile_image").child(uid)
            guard let image = profileImage.image else {return}
            if let newImage = image.jpegData(compressionQuality: 0.1){
                storageItem.putData(newImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        if let profilePhotoURL = url?.absoluteString{
                            guard let newUserName  = self.accName.text else {return}
                            
                            let newValuesForProfile = ["profile_image": profilePhotoURL,"username": newUserName]
                            
                            self.databaseRef.child("users").child(uid).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                            })
                        }
                    })
                })
            }
        }
    }
    
    
    
    func getData() {
        let currentUserID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == currentUserID {
                        if let _ = value["username"] as? String, let profileUrl = value["profile_image"] as? String {
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
    
}
