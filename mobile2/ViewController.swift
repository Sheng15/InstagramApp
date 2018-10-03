//
//  ViewController.swift
//  mobile2
//
//  Created by LudwiG on 2018/9/19.
//  Copyright © 2018年 LudwiG. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil{
            let avt = self.storyboard?.instantiateViewController(withIdentifier: "h1")
            self.present(avt!, animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBOutlet weak var unTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBAction func sinBT(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        let username = unTF.text
        let password = pwTF.text
        
        Auth.auth().signIn(withEmail: username ?? " ", password: password ?? " ") { (user, error) in
            if error != nil{
                let em = error?.localizedDescription
                ProgressHUD.showError(em!)
            } else {
                ProgressHUD.showSuccess("Success")
                let avt = self.storyboard?.instantiateViewController(withIdentifier: "h1")
                self.present(avt!, animated: true, completion: nil)
            }
        }
    }
    
}

