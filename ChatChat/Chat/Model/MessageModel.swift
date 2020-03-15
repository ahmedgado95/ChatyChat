//
//  MessageModel.swift
//  ChatChat
//
//  Created by A on 10/03/2020.
//  Copyright © 2020 Ahmed Gado. All rights reserved.
//

import Foundation
import Firebase
struct MessageModel {
    var fromId : String?
    var toId : String?
    var timeStamp : NSNumber?
    var text : String?
    func chatPartnerId() -> String? {
          return fromId == Auth.auth().currentUser?.uid ? toId : fromId
      }
}
