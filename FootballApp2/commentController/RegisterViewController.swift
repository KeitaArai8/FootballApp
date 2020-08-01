//
//  RegisterViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/26.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct User {
    
    let name:String
    let createdAt:Timestamp
    let email:String
    
    init(dic: [String:Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}

struct commentURL {
    
    let name:String
    let url:String
    let createdAt:Timestamp
    
    init(dic: [String:Any]) {
        self.url = dic["url"] as! String
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
    }
}



class RegisterViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var alertController: UIAlertController!
    
    @IBAction func tapLoginButton(_ sender: Any) {
        
        handleAuthToFirebase()
        alert(title: "エラー", message: "新規登録に失敗しました")
        
    }
    
    func alert(title:String, message:String) {
        
        alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
        present(alertController, animated: true)
        
    }
    
    @IBAction func LoginUserButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func handleAuthToFirebase() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err{
                
                print("認証に失敗しました\(err)")
                return
            }
            
            self.addUserInfoToFirestore(email: email)
        }
        
    }
    
    private func addUserInfoToFirestore(email: String){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = self.usernameTextField.text else {return}
        
        let docData = ["email": email, "name":name, "createdAt":Timestamp()] as [String : Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData) { (err) in
            if let err = err{
                
                print("保存に失敗しました\(err)")
                return
            }
            
            userRef.getDocument { (snapshot, err) in
                if let err = err{
                    
                    print("ユーザー情報の取得に失敗しました\(err)")
                    return
                }
                
                guard let data = snapshot?.data() else {return}
                let user = User.init(dic: data)
                
                print("ユーザー情報の取得に成功しました\(user.name)")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let chatVC = storyboard.instantiateViewController(withIdentifier: "SelectChat") as! SelectChatViewController
                chatVC.user = user
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
            print("保存に成功しました")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginButton.isEnabled = false
        LoginButton.layer.cornerRadius = 10.0
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showkeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showkeyboard(notification: Notification){
        
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let LoginButtonMaxY = LoginButton.frame.maxY
        
        let distance = LoginButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
        
    }
    
    @objc func hidekeyboard(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
        
    }
    
//    @IBAction func back(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty{
            
            LoginButton.isEnabled = false
            LoginButton.backgroundColor = #colorLiteral(red: 0.4211993217, green: 0.6246983409, blue: 1, alpha: 0.4330318921)
        }else{
            LoginButton.backgroundColor = #colorLiteral(red: 0.4080507755, green: 0.6055637002, blue: 0.9942765832, alpha: 1)
            LoginButton.isEnabled = true
            
        }
        
    }
    
}
