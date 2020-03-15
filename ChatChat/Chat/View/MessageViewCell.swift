//
//  MessageViewCell.swift
//  ChatChat
//
//  Created by A on 10/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {
     enum bubbleType {
            case inComing
            case outGoing
        }
        @IBOutlet weak var timeStampLabel: UILabel!
        @IBOutlet weak var chatContainerView: UIView!
           @IBOutlet weak var chatStackView: UIStackView!
        @IBOutlet weak var userNameLabel: UILabel!
        
        @IBOutlet weak var chatTextView: UITextView!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            chatContainerView.layer.cornerRadius = 8
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        func congigerCell (item : MessageModel) {
            userNameLabel.text = item.fromId
            chatTextView.text = item.text
        }
        func setBubbleType(type : bubbleType) {
            if type == .inComing {
                chatStackView.alignment = .leading
                chatContainerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                chatTextView.textColor = .black
    //            userNameLabel.tintColor = .black
            }else if type == .outGoing {
                chatStackView.alignment = .trailing
                chatContainerView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.4039215686, blue: 1, alpha: 0.9175286092)
                chatTextView.textColor = .white
    //            userNameLabel.tintColor = .yellow


            }
        }

    }
