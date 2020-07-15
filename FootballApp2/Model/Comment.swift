//
//  Comment.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/09.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import Foundation
import Firebase


class Comment{
    
    let name:String
    let comment:String
    let uid:String
    let createdAt:Timestamp
    
    init(dic: [String:Any]) {
        self.comment = dic["comment"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
