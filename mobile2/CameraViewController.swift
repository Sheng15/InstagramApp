//
//  CameraViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/9/30.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class CameraViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageData: UIImageView!
    @IBOutlet weak var rmBT: UIButton!
    @IBOutlet weak var TextData: UITextView!
    @IBOutlet weak var ShareBT: UIButton!
    var SelectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextData.layer.borderColor = UIColor.black.cgColor
        TextData.layer.borderWidth = 1.0;
        TextData.layer.cornerRadius = 5.0;
        TextData.delegate = self
        TextData.text = "Say something..."
        TextData.textColor = UIColor.lightGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handlePhoto))
        ImageData.addGestureRecognizer(tapGesture)
        ImageData.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handlePost()
    }
    
    @IBAction func removeBT(_ sender: Any) {
        self.TextData.text = ""
        self.ImageData.image = UIImage(named: "icon0.png")
        self.SelectedImage = nil
        handlePost()
    }
    func handlePost() {
        if SelectedImage != nil {
            self.ShareBT.isEnabled = true
            self.rmBT.isEnabled = true
            self.ShareBT.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.ShareBT.isEnabled = false
            self.rmBT.isEnabled = false
            self.ShareBT.backgroundColor = .lightGray
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Say something..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func PostBT(_ sender: Any) {
        
        view.endEditing(true)
        
        ProgressHUD.show("Waiting...", interaction: false)
        if let selected = SelectedImage, let imageDT = selected.jpegData(compressionQuality: 1.0){
            
            let uniqueString = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("AppCodaFireUpload").child(uniqueString)
            storageRef.putData(imageDT, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                storageRef.downloadURL { imageURL, error in
                    let url = imageURL?.absoluteString
                    self.send2Database(photoUrl: url!)
                    ProgressHUD.showSuccess("Success!")
                    let avt = self.storyboard?.instantiateViewController(withIdentifier: "h1")
                    self.present(avt!, animated: true, completion: nil)
                }
            })
        } else {
            ProgressHUD.showError("Please choose an Image!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func send2Database(photoUrl: String){
        
        let ref = Database.database().reference()
        let postReferrence = ref.child("posts")
        let newPostID = postReferrence.childByAutoId().key
        let newPostReferrence = postReferrence.child(newPostID!)
        newPostReferrence.setValue(["photoUrl": photoUrl,"text": TextData.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success!")
            self.TextData.text = ""
            self.ImageData.image = UIImage(named: "icon0.png")
            self.SelectedImage = nil
        })
    }
    
    @objc func handlePhoto() {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.camera)
        }))
    
        actionSheet.addAction(UIAlertAction(title: "PHOTO LIBRARY", style: .default, handler: { alertAction in
            self.showImagePickerForSourceType(.photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler:nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePickerForSourceType(_ sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async(execute: {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .currentContext
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        
        ImageData.image = image
        SelectedImage = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
