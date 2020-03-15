//
//  ViewController.swift
//  ChatChat
//
//  Created by A on 09/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit
import Firebase

class LoginVc: UIViewController {
    @IBOutlet weak var emailTextFiled: UITextField!
    
    @IBOutlet weak var passTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Login"
        hideKeyboardWhenTappedAround()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        validateLogin()
    }
    func validateLogin(){
        guard let email = emailTextFiled.text , let password = passTextFiled.text else {return}
        if(email.isEmpty == true || password.isEmpty == true){
            self.showAlert(title: "", message: "Please fill empty fields", okAction: "ok")

        } else {
            getLogin(email: email, password: password)
        }
    }
    
    func getLogin( email : String , password : String){
      Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
          if(error == nil){
           print(result?.user)
            let vc = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
          } else {
            self.showAlert(title: "", message: "Wrong username or password", okAction: "ok")

          }
      }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "RegisterVc") as! RegisterVc
        self.navigationController?.pushViewController(vc, animated: true)

    }
   
}

