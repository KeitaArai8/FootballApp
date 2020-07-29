//
//  SaveComment.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/20.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import Foundation
import Firebase

struct ChatModel {
    
    static var user: User?
    static var messages = [Comment]()
    
}

protocol ChatDelegate {
    func messagesAppend(messages: [Comment])
}

class Chat{
    
    var delegate:ChatDelegate?
    
    func fetchComment(roomId:String){
        
        ChatModel.messages = []
        
        Firestore.firestore().collection("chatRoom").document(roomId).collection("comment").addSnapshotListener { (snapshots, err) in
            if let err = err{
                print("コメントの取得に失敗しました\(err)")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type{
                    
                case.added:
                    let dic = documentChange.document.data()
                    let comment = Comment(dic: dic)
                    ChatModel.messages.append(comment)
                    ChatModel.messages.sort { (m1, m2) -> Bool in
                        let miDate = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return miDate < m2Date
                    }
                    self.delegate?.messagesAppend(messages: ChatModel.messages)
                case.modified,.removed:
                    print("no")
                }
            })
            
        }
        
    }
    
    
    
}
