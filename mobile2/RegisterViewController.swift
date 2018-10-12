//
//  RegisterViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/9/19.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Photos

class RegisterViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var un2TF: UITextField!
    @IBOutlet weak var pw2TF: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var accName: UITextField!
    @IBOutlet weak var pw3TF: UITextField!
    var SelectedImage: UIImage?
    var uuid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.borderWidth = 1.0;
        avatar.layer.cornerRadius = 1.0;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handlePhoto))
        avatar.addGestureRecognizer(tapGesture)
        avatar.isUserInteractionEnabled = true
        
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    @IBAction func createBT(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        let username_r = un2TF.text
        let accname_r = accName.text
        let password1_r = pw2TF.text
        let password2_r = pw3TF.text
        
        if username_r == "" {
            ProgressHUD.showError("Need to enter your email!")
        }
        else if password1_r != password2_r{
            ProgressHUD.showError("Should enter the same password twice!")
        } else {
            if self.SelectedImage != nil{
                Auth.auth().createUser(withEmail: username_r!, password: password2_r!) { (user, error) in
                    
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    self.uuid = user?.user.uid
                    print(self.uuid!)
                    if self.uuid != nil {
                        let selected = self.SelectedImage
                        let imageDT = selected!.jpegData(compressionQuality: 0.1)
                        let storageRef = Storage.storage().reference().child("profile_image").child(self.uuid!)
                        
                        
                        
                        
                        storageRef.putData(imageDT!, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                ProgressHUD.showError(error?.localizedDescription)
                                return
                            }
                            storageRef.downloadURL { imageURL, error in
                                let url = imageURL?.absoluteString
                                let ref = Database.database().reference()
                                let usersReference = ref.child("users")
                                let newUsersReference = usersReference.child(self.uuid!)
                                newUsersReference.setValue(["uid": self.uuid,"username": accname_r,"email": username_r, "profile_image": url!])
                                ProgressHUD.showSuccess("Success!")
                                let avt = self.storyboard?.instantiateViewController(withIdentifier: "ss")
                                self.present(avt!, animated: true, completion: nil)
                            }
                        })
                    }
                }
            } else {
                ProgressHUD.showError("Please choose an Image!")
                return
            }
        }
    }
    
    @objc func handlePhoto() {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        
        avatar.image = image
        SelectedImage = image
        
        picker.dismiss(animated: true, completion: nil)
    }
}
