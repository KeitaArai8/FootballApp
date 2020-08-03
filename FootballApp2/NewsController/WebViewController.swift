//
//  WebViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/16.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class WebViewController: UIViewController,WKUIDelegate {
    
    var webView = WKWebView()
    var toolbar = UIToolbar()
    var urlStirng:String?
    var activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        let urlString = urlStirng
        let url = URL(string: urlString!)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        toolbar.frame = CGRect(x: 0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 50)
        toolbar.layer.zPosition = 2
        toolbar.backgroundColor = .lightGray
        
        toolbar.barStyle = .default
         
        let buttonSize: CGFloat = 24
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        backButton.setBackgroundImage(UIImage(named: "arrow_left"), for: UIControl.State())
        backButton.addTarget(self, action: #selector(self.onClickBack(_:)), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        let commentButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        commentButton.setBackgroundImage(UIImage(named: "message"), for: UIControl.State())
        commentButton.addTarget(self, action: #selector(self.onCommentClose(_:)), for: .touchUpInside)
        let commentButtonItem = UIBarButtonItem(customView: commentButton)
       
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [backButtonItem, flexibleItem, flexibleItem, flexibleItem, commentButtonItem]
        
        activityIndicatorView.backgroundColor = .gray
        activityIndicatorView.style = .large
        activityIndicatorView.center = view.center
        activityIndicatorView.color = .blue
        activityIndicatorView.startAnimating()
        
        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 2)

            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        view.addSubview(toolbar)
        view.addSubview(activityIndicatorView)
    }
    
    @objc func onClickBack(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
     
    @objc func onCommentClose(_ sender: UIButton) {
        
        addURL()
        
        guard let url = urlStirng else {return}
        let textChange = (url as AnyObject).components(separatedBy: CharacterSet.controlCharacters
        .union(CharacterSet.whitespaces)
        .union(CharacterSet.punctuationCharacters)
        .union(CharacterSet.symbols)
        ).joined()
        print(textChange)
        
        let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PostedArticles") as! PostedArticlesViewController
        commentVC.modalPresentationStyle = .currentContext
        commentVC.urlCollectionId = textChange
        present(commentVC, animated: true, completion: nil)
        
    }
    
    
    func addURL(){
        
        guard let url = urlStirng else {return}
        let textChange = (url as AnyObject).components(separatedBy: CharacterSet.controlCharacters
        .union(CharacterSet.whitespaces)
        .union(CharacterSet.punctuationCharacters)
        .union(CharacterSet.symbols)
        ).joined()
        
        let urlDoc = "webURL"
        let docData = ["url":url,"createdAt":Timestamp()] as [String : Any]
        Firestore.firestore().collection("chat").document(String(textChange)).collection(urlDoc).document("URL").setData(docData) { (err) in
            if let err = err{
                print("URLの保存に失敗しました\(err)")
                return
            }
            print("URLの保存に成功しました")
        }
    }

}
