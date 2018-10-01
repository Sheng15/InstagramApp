//
//  registerViewController.swift
//  swiftagram
//
//  Created by Tianhang ZHANG on 23/9/18.
//  Copyright © 2018 Tianhang ZHANG. All rights reserved.
//

import UIKit
import Firebase


class registerViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func creatAccountTapped(_ sender: Any) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        Auth.auth().createUser(withEmail: username!, password: password!,completion:
            {(user, error) in
                if error != nil{
                    
                    let errorMesage = error?.localizedDescription
                    let alert = UIAlertController(title: "Error", message: errorMesage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                    self.present(alert, animated: true ,  completion: nil)
                }else {
//                    succeed
//                    let alert = UIAlertController(title: "success", message: "account created", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
//                    self.present(alert, animated: true ,  completion: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                    
                    self.present(vc! , animated: true, completion: nil)
                }
                
            
        })
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
