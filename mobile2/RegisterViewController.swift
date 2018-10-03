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

class RegisterViewController: UIViewController {

    @IBOutlet weak var un2TF: UITextField!
    @IBOutlet weak var pw2TF: UITextField!
    @IBOutlet weak var pw3TF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func createBT(_ sender: Any) {
        view.endEditing(true)
        let username_r = un2TF.text
        let password1_r = pw2TF.text
        let password2_r = pw3TF.text
        
        if username_r == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your account name!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else if password1_r != password2_r{
            let alertController = UIAlertController(title: "Error", message: "Please enter the same password twice!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: username_r!, password: password2_r!) { (user, error) in
                
                if error == nil {
                    ProgressHUD.showSuccess("Success!")
                    let avt = self.storyboard?.instantiateViewController(withIdentifier: "ss")
                    self.present(avt!, animated: true, completion: nil)
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
