//
//  MenuViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/13.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let menuPos = self.menuView.layer.position
        
        self.menuView.layer.position.x = -self.menuView.frame.width
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
        
    }
    
    // メニュー以外タップ時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    @IBAction func newsButton(_ sender: Any) {
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.menuView.layer.position.x = -self.menuView.frame.width
        },
            completion: { bool in
                self.dismiss(animated: true, completion: nil)
        }
        )
        
    }
    
    @IBAction func scheduleAction(_ sender: Any) {
        
    }
    
    @IBAction func ChatButton(_ sender: Any) {
        
        let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Comment") as! CommentViewController
        commentVC.modalPresentationStyle = .fullScreen
        present(commentVC, animated: true, completion: nil)
        
    }
    
    
    
}
