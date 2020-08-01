//
//  LoginViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/26.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    var alertController : UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        LoginButton.isEnabled = false
        LoginButton.layer.cornerRadius = 10.0
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        if self.checkUserVerify() {
            self.transitionToView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showkeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidekeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func checkUserVerify()  -> Bool {
        
        guard Auth.auth().currentUser != nil else { return false }
        return true
    }
    
    func transitionToView()  {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "SelectChat") as! SelectChatViewController
        self.navigationController?.pushViewController(chatVC, animated: true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func setUpButton(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let registerVC = storyboard.instantiateViewController(withIdentifier: "next") as! RegisterViewController
               self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func alert(title:String, message:String) {
        
        alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
        present(alertController, animated: true)
        
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err{
                
                self.alert(title: "エラー", message: "ログインに失敗しました")
                print("ログインに失敗しました\(err)")
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let userRef = Firestore.firestore().collection("users").document(uid)
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
        }
        
    }
    
}


extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            
            LoginButton.isEnabled = false
            LoginButton.backgroundColor = #colorLiteral(red: 0.4211993217, green: 0.6246983409, blue: 1, alpha: 0.4330318921)
        }else{
            LoginButton.backgroundColor = #colorLiteral(red: 0.4080507755, green: 0.6055637002, blue: 0.9942765832, alpha: 1)
            LoginButton.isEnabled = true
        }
    }
    
    
}
