//
//  PostViewController.swift
//  swiftagram
//
//  Created by Tianhang ZHANG on 23/9/18.
//  Copyright © 2018 Tianhang ZHANG. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var imageFileName = ""

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!

    @IBOutlet weak var previewImageView: UIImageView!
    var ref: DatabaseReference?
    var imageRefer: StorageReference?
  
    @IBOutlet weak var selectImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        imageRefer = Storage.storage().reference()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    let randomName = randomStringImageName(length: 10)

    func uploadImage(image: UIImage){
        let randomName = randomStringImageName(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let xxx = imageRefer?.child("images/\(randomName).jpg")
        
        
        _ = xxx?.putData(imageData!, metadata: nil){
            metadata, error in
            if error == nil {
                // success
                print("successfully uploaded image.")
                self.imageFileName = "\(randomName as String).jpg"
            }else{
                //error
                print("error upload")
                
            }
        }
    }
    

    @IBAction func PostTapped(_ sender: Any) {
        
        if let uid = Auth.auth().currentUser?.uid{
            if let title = titleTextField.text{
                if let content = contentTextView.text{
                    let postObject : Dictionary<String, Any> = [
                        
                        "uid" : uid,
                        "title" : title,
                        "content" : content,
                        "image" : imageFileName
                    ]
                    ref?.child("post").childByAutoId().setValue(postObject)
                    presentingViewController?.dismiss(animated: true, completion: nil)
                   

                    let alert = UIAlertController(title: "Success!", message: "your moment has posted!😀", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                    self.present(alert, animated: true ,  completion: nil)
                    
                    
                     print("posted to firbase")
                }
            }
        }
    }
    
    @IBAction func selectImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    func randomStringImageName(length: Int) -> NSString{
        let char : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: length)
        
        for _ in 0..<length{
            let len = UInt32(char.length)
            let rand = arc4random_uniform(len)
            randomString.appendFormat("%C", char.character(at: Int(rand)))
        }
        return randomString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //when user hits cancel
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //when finishing selected image from photo library
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.previewImageView.image = pickedImage
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
