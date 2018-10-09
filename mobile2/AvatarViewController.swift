//
//  AvatarViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/9/23.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import Firebase

class AvatarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var Avatars: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func ChangeBT(_ sender: Any) {
        
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
            ////////////////////////////////////////
            /*
             We actually have two delegates:UIImagePickerControllerDelegate and UINavigationControllerDelegate. The UINavigationControllerDelegate is required but we do nothing with it.
             Add the following:
             */
            imagePickerController.delegate = self
            
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        
        self.Avatars.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBT(_ sender: Any) {
        
        let avt = self.storyboard?.instantiateViewController(withIdentifier: "ou")
        self.present(avt!, animated: true, completion: nil)
    }
    
}
