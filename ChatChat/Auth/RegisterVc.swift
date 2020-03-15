//
//  RegisterVc.swift
//  ChatChat
//
//  Created by A on 09/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit
import Firebase

class RegisterVc: UIViewController {
    
    @IBOutlet weak var passTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var PioImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelAction))
        PioImage.addGestureRecognizer(tap)
    }
    @objc func handelAction (){
        print("Open Picker Image")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        validateLogin()
    }
    func validateLogin(){
        guard let email = emailTextFiled.text , let password = passTextFiled.text , let name = nameTextFiled.text else {return}
        if(email.isEmpty == true || password.isEmpty == true){
            self.showAlert(title: "", message: "Please fill empty fields", okAction: "ok")
            
        } else {
            getRegister(email: email, password: password, name: name)
        }
    }
    
    func getRegister( email : String , password : String , name : String){
        Auth.auth().createUser(withEmail: email, password: password) { (success, error) in
            if error == nil {
                // success
                guard let userId = success?.user.uid else {return}
                
                // upload image to storage
                 let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child(Constants.mYIMAGE).child("\(imageName).png")
                if let imageData = self.PioImage.image?.jpegData(compressionQuality: 0.75) {
                    storageRef.putData(imageData, metadata: nil) { (success, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        print(success)
                        storageRef.downloadURL(completion: { (url, err) in
                            if let err = err {
                                print(err)
                                return
                            }
                            guard let url = url else { return }
                            
                            let value:[String: Any] = [Constants.uSERNAME: name , Constants.eMAIL : email , "Password" : password , Constants.pROFILEIMAGEURL : url.absoluteString]
                            
                            self.addDataRef(uid: userId, value: value)
                        })
                    }
                }
                
                
            }else {
                // error
                print(error?.localizedDescription)
                //                self.showAlert(title: "", message: error!.localizedDescription, okAction: "Ok")
            }
        }
        
    }
    func addDataRef(uid : String , value:[String: Any] ) {
        let reference = Database.database().reference()
        let user = reference.child(Constants.uSERS).child(uid)
        user.setValue(value)
        self.emptyFiled()
    }
    func emptyFiled()  {
        resetText(text: passTextFiled)
        resetText(text: nameTextFiled)
        resetText(text: emailTextFiled)
        let vc = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func resetText(text : UITextField) -> Void {
        return text.text = ""
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
extension RegisterVc : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            print(editedImage.size)
            selectedImage = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            print(originalImage.size)
            selectedImage = originalImage
        }
        PioImage.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Picker")
        dismiss(animated: true, completion: nil)
    }
}
