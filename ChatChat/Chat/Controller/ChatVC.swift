//
//  ChatVC.swift
//  ChatChat
//
//  Created by A on 10/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit
import Firebase

class ChatVC : UIViewController {
    var user :UserModel? {
        didSet {
            self.title = user?.name
            obserMessage()
        }
    }
    var chatMessageSource = [MessageModel]()

    @IBOutlet weak var messageTextFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageTextFiled.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        print("Send")
    sendMessage()
    }
    
    func sendMessage(){
        let ref = Database.database().reference().child(Constants.mESSAGE)
        let childRef = ref.childByAutoId()
        let messageToId = user!.id!
        let messageFromId = Auth.auth().currentUser!.uid
        let timeStampe = Int(Date().timeIntervalSince1970)
        let value : [String : Any] = [Constants.tEXT : messageTextFiled.text! , Constants.sENDTOID :messageToId , Constants.sENDFROMID : messageFromId , Constants.tIMESTAMP : timeStampe]
        childRef.updateChildValues(value) { (error, ref) in
                   if error != nil {
                       print(error.debugDescription)
                       return
                   }
                   
                   guard let messageId = childRef.key else {return}
            let userMessagesRef = Database.database().reference().child(Constants.uSERMESSAGE).child(messageFromId)
                   userMessagesRef.updateChildValues([messageId : 1])
               }
        self.messageTextFiled.text = ""
    }
    
    func obserMessage(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMessageRef = Database.database().reference().child(Constants.uSERMESSAGE).child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child(Constants.mESSAGE).child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapShot) in
                print(snapShot)
                guard let dic = snapShot.value as? [String : Any] else {return}
                let message = MessageModel.init(fromId: dic[Constants.sENDFROMID] as? String, toId:  dic[Constants.sENDTOID] as? String, timeStamp:  dic[Constants.tIMESTAMP] as? NSNumber, text: dic[Constants.tEXT] as? String)
                if message.chatPartnerId() == self.user?.id {
                    self.chatMessageSource.append(message)
                    self.tableView.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
}
extension ChatVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
extension ChatVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessageSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = chatMessageSource[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = item.text
        return cell
    }
    
    
}
