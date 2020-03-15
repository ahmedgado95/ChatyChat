//
//  UserVC.swift
//  ChatChat
//
//  Created by A on 10/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UITableViewController {
    var userSource = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.registerCellNib(cellClass: UserViewCell.self)
        featchUserS()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    func featchUserS(){
        let ref = Database.database().reference().child(Constants.uSERS)
            ref.observe(.childAdded, with: { (snapchot) in
                print(snapchot)
                if let dict = snapchot.value as? [String:Any] {
                   // print(dict)
                    var user = UserModel.init(name: dict[Constants.uSERNAME] as? String, email: dict[Constants.eMAIL] as? String, profileImage: dict[Constants.pROFILEIMAGEURL] as? String)
                    user.id  = snapchot.key
                    self.userSource.append(user)
                    self.tableView.reloadData()
                }
            }, withCancel: nil)
    }
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as UserViewCell
        let item = userSource[indexPath.row]
        // Configure the cell...
        cell.configerCell(item: item)
    
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = userSource[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "ChatVC") as! ChatVC
        vc.user = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    

}
