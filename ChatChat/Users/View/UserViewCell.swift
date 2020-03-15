//
//  UserViewCell.swift
//  ChatChat
//
//  Created by A on 10/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit
import Firebase

class UserViewCell: UITableViewCell {
    var message : MessageModel? {
        didSet {
          setUImageAndName()
            emailLabel.text = message?.text
            timeLabel.isHidden = false
                 if let seconds = message?.timeStamp?.doubleValue {
                          let timestampDate = Date(timeIntervalSince1970: seconds)
                          
                          let dateFormatter = DateFormatter()
                          dateFormatter.dateFormat = "hh:mm:ss a"
                          timeLabel.text = dateFormatter.string(from: timestampDate)
                      }
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pioImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pioImage.makeRounded()
    }
    func configerCell (item : UserModel) {
        emailLabel.text = item.email
        nameLabel.text = item.name
        if let profileImageUrl = item.profileImage {
            pioImage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
    }
    
    func setUImageAndName(){

        if let id = message?.chatPartnerId() {
                      let ref = Database.database().reference().child(Constants.uSERS).child(id)
                      ref.observeSingleEvent(of: .value, with: { (snapshot) in
                          print(snapshot)
                          if let dic = snapshot.value as? [String: Any] {
                              self.nameLabel.text = dic[Constants.uSERNAME] as? String
                              if let profileImage = dic[Constants.pROFILEIMAGEURL] as? String {
                                  self.pioImage.loadImageUsingCacheWithUrlString(profileImage)
                              }
                          }
                      }, withCancel: nil)
                  }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
