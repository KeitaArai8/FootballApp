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

class Chat4ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var user: User?
    var messages = [Comment]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var chatArray = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        tableView.backgroundColor = .systemBlue
        
        messageTextField.text = ""
        messageTextField.delegate = self
        
        

        self.navigationItem.title = "ブンデスリーガ掲示板"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        fetchComment()
        
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! CustomCell
        
        cell.comment = messages[indexPath.row]
        cell.usernameLabel.text = user?.name
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
        
        SaveComment(room: "BundesLiga")
        
        messageTextField.text = ""
        
    }
    
    
    func SaveComment(room:String){
        
        guard let name = self.user?.name else {return}
        guard let comment = messageTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let roomId = room
        
        
        let docData = ["name":name,"comment":comment,"createdAt":Timestamp(),"uid":uid] as [String : Any]
        Firestore.firestore().collection("chatRoom").document(roomId).collection("comment").addDocument(data: docData){ (err) in
            if let err = err{
                print("コメントの保存に失敗しました\(err)")
                return
            }
            print("コメントの保存に成功しました")
        }
        
    }
    
    
    
    func fetchComment(){
        
        let roomId = "BundesLiga"
        
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
                    self.messages.append(comment)
                    self.messages.sort { (m1, m2) -> Bool in
                        let miDate = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return miDate < m2Date
                    }
                    self.tableView.reloadData()
                    
                case.modified,.removed:
                    print("no")
                }
            })
            
        }
        
    }
    
    
    
}



