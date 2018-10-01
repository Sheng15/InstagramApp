//
//  ViewController.swift
//  swiftagram
//
//  Created by Tianhang ZHANG on 23/9/18.
//  Copyright © 2018 Tianhang ZHANG. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: username!, password: password!,completion:{(user, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "Incorrect username/password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(alert, animated: true ,  completion: nil)
                
            }
            else{
//                succeed login
//                let alert = UIAlertController(title: "Success!", message: "you are logged in ", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
//                self.present(alert, animated: true ,  completion: nil)
              
                
                
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostVC")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                
                self.present(vc! , animated: true, completion: nil)
            
            }
            
            
            
        }
        
        
        
        )
    }
    
}

