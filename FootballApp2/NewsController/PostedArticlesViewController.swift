//
//  PostedArticlesViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/08.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PostedArticlesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var messages = [Comment]()
//     var messages = [String]()
    var urlCollectionId:String?
    
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
        
        fetchComment()
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
//        cell.commentLabel.text = messages[indexPath.row]
        cell.usernameLabel.text = "匿名"
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
        
//        let text = messageTextField.text
//        messages.append(text!)
        
        SaveComment()
        
        messageTextField.text = ""
        
        self.tableView.reloadData()
    }
    
    
    private func SaveComment(){
        
        let id = "匿名"
        let urlDoc = "commentData"
        
        guard let comment = messageTextField.text else {return}
        guard let urlCollectionId = urlCollectionId else {return}
        
        let docData = ["id":id,"comment":comment,"createdAt":Timestamp()] as [String : Any]
        Firestore.firestore().collection("chat").document(urlCollectionId).collection(urlDoc).addDocument(data: docData){ (err) in
            if let err = err{
                print("コメントの保存に失敗しました\(err)")
                return
            }
            print("コメントの保存に成功しました")
        }
        
    }
        
    func fetchComment(){
        let urlDoc = "commentData"
        guard let urlCollectionId = urlCollectionId else {return}
        
        Firestore.firestore().collection("chat").document(urlCollectionId).collection(urlDoc).addSnapshotListener { (snapshots, err) in
            if let err = err{
                
                print("コメントの取得に失敗しました\(err)")
                return
            }
            print("コメントの取得に成功しました")
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


