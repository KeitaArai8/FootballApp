//
//  Message.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/02.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import Foundation
import Firebase

class Message{
    
    let id:String
    let comment:String
    let createdAt:Timestamp
    
    var collectionUrl:String?
    
    
    init(dic: [String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.comment = dic["comment"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
