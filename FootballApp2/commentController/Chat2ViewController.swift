//
//  ChatViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/01.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Chat2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ChatDelegate {
    
    var ChatClass = Chat()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        tableView.backgroundColor = .systemBlue
        
        messageTextField.text = ""
        messageTextField.delegate = self
        
        

        self.navigationItem.title = "ラ・リーガ掲示板"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        ChatClass.fetchComment(roomId: "LaLiga")
        messagesAppend(messages: ChatModel.messages)
        
    }
    
    func messagesAppend(messages: [Comment]) {
        ChatModel.messages = messages
        ChatClass.delegate = self
        self.tableView.reloadData()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if messageTextField.text!.isEmpty{
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        messageTextField.resignFirstResponder()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! CustomCell
        
        cell.comment = ChatModel.messages[indexPath.row]
        cell.usernameLabel.text = ChatModel.user?.name
        cell.usernameLabel.textColor = .white
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        return 100
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        sendButton.isEnabled = false
        
        SaveComment(roomId: "LaLiga")
        
        messageTextField.text = ""

    }
    
    func SaveComment(roomId:String){
        
        guard let name = ChatModel.user?.name else {return}
        guard let comment = messageTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}

        let docData = ["name":name,"comment":comment,"createdAt":Timestamp(),"uid":uid] as [String : Any]
        Firestore.firestore().collection("chatRoom").document(roomId).collection("comment").addDocument(data: docData){ (err) in
            if let err = err{
                print("コメントの保存に失敗しました\(err)")
                return
            }
            print("コメントの保存に成功しました")
        }
        
    }



}



