//
//  HomeVC.swift
//  ChatChat
//
//  Created by A on 10/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pioImage: UIImageView!
    var messageSource = [MessageModel]()
    var messageDic = [String : MessageModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
               tableView.dataSource = self
        observUserMessage()
        tableView.registerCellNib(cellClass: UserViewCell.self)

        // Do any additional setup after loading the view.
        feachUsser()
        pioImage.makeRounded()
          let tap = UITapGestureRecognizer(target: self, action: #selector(handelAction))
            nameLabel.addGestureRecognizer(tap)
        }
        @objc func handelAction (){
            print("Open Chat")
        let vc = storyboard?.instantiateViewController(identifier: "ChatVC") as! ChatVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
 
    
    @IBAction func logOutButtonpressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let vc = storyboard?.instantiateViewController(identifier: "LoginVc") as! LoginVc
            let nav = UINavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow?.rootViewController = nav
        }catch let error {
            print(error)
        }
    }
    
    // featch User From FireBase
    func feachUsser (){
        self.messageSource.removeAll()
       self.messageDic.removeAll()
          observMessage()

        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = Database.database().reference()
        reference.child(Constants.uSERS).child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            if let dic = snapShot.value as? [String : AnyObject] {
                if let userName = dic[Constants.uSERNAME] as? String {
//                    self.title = userName
        
                    if let profileImageUrl = dic[Constants.pROFILEIMAGEURL] as? String {
                        self.pioImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                        self.nameLabel.text = userName
                    }
                    print(userName)
                }
                
            }
        }, withCancel: nil)
    }
    
    @IBAction func showAllUserButtonPressed(_ sender: Any) {
        print("Hi")
        let vc = storyboard?.instantiateViewController(identifier: "UserVC") as! UserVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func observUserMessage(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database()
            .reference().child(Constants.uSERMESSAGE).child(uid)
        ref.observe(.childAdded) { (snapshot) in
            print(snapshot)
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child(Constants.mESSAGE).child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dict = snapshot.value as? [String:Any] {
                    print(dict)
                    var user = UserModel.init(name: dict[Constants.uSERNAME] as? String, email: dict[Constants.eMAIL] as? String, profileImage: dict[Constants.pROFILEIMAGEURL] as? String)
                    //                                   user.id  = snapchot.key
                    //                                   self.userSource.append(user)
                    //                                   self.tableView.reloadData()
                    let message = MessageModel(fromId: dict[Constants.sENDFROMID] as? String, toId: dict[Constants.sENDTOID] as? String, timeStamp: dict[Constants.tIMESTAMP] as? NSNumber, text: dict[Constants.tEXT] as? String)
                    print(message.text)
                    //                    self.messageSource.append(message)
                    if let toId =  message.toId {
                        self.messageDic[toId] = message
                        self.messageSource = Array(self.messageDic.values)
                        self.messageSource.sort(by: { (message1, message2) -> Bool in
                            return message1.timeStamp!.int32Value > message2.timeStamp!.int32Value
                            
                        })
                        
                    }
                    self.tableView.reloadData()
                    
                }
            }, withCancel: nil)
        }
    }
     func observMessage(){
            let ref = Database.database().reference().child(Constants.mESSAGE)
            ref.observe(.childAdded, with: { (snapShot) in
                print(snapShot)
                if let dict = snapShot.value as? [String:Any] {
                     print(dict)
                     var user = UserModel.init(name: dict[Constants.uSERNAME] as? String, email: dict[Constants.eMAIL] as? String, profileImage: dict[Constants.pROFILEIMAGEURL] as? String)
    //                                   user.id  = snapchot.key
    //                                   self.userSource.append(user)
    //                                   self.tableView.reloadData()
                    let message = MessageModel(fromId: dict[Constants.sENDFROMID] as? String, toId: dict[Constants.sENDTOID] as? String, timeStamp: dict[Constants.tIMESTAMP] as? NSNumber, text: dict[Constants.tEXT] as? String)
                    print(message.text)
//                    self.messageSource.append(message)
                    if let toId =  message.toId {
                        self.messageDic[toId] = message
                        self.messageSource = Array(self.messageDic.values)
                        self.messageSource.sort(by: { (message1, message2) -> Bool in
                            return message1.timeStamp!.int32Value > message2.timeStamp!.int32Value

                        })
                        
                    }
                    self.tableView.reloadData()

                }
            }, withCancel: nil)
        }
}
extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as UserViewCell
        // Configure the cell...
        let item = messageSource[indexPath.row]
        cell.message = item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let item = messageSource[indexPath.row]
        guard let chatPartnerId = item.chatPartnerId() else {return}

            let ref = Database.database().reference().child(Constants.uSERS).child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                return
            }
                var user = UserModel.init(name: dict[Constants.uSERNAME] as? String, email: dict[Constants.eMAIL] as? String, profileImage: dict[Constants.pROFILEIMAGEURL] as? String)
                user.id = chatPartnerId
                let vc = self.storyboard?.instantiateViewController(identifier: "ChatVC") as! ChatVC
                       vc.user = user
                       self.navigationController?.pushViewController(vc, animated: true)

            }, withCancel: nil)
        }

    }


