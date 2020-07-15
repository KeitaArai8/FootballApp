//
//  SelectChatViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/08.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import Firebase

class SelectChatViewController: UIViewController {
    
    
    @IBOutlet weak var premier: UIButton!
    @IBOutlet weak var laliga: UIButton!
    @IBOutlet weak var serieA: UIButton!
    @IBOutlet weak var bundes: UIButton!
    @IBOutlet weak var CL: UIButton!
    
    var user: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        premier.setImage(UIImage(named: "premier2"), for: UIControl.State.normal)
        laliga.setImage(UIImage(named: "LaLiga"), for: UIControl.State.normal)
        serieA.setImage(UIImage(named: "serieA"), for: UIControl.State.normal)
        bundes.setImage(UIImage(named: "bundes"), for: UIControl.State.normal)
        CL.setImage(UIImage(named: "CL"), for: UIControl.State.normal)
        
        
    }
    
    @IBAction func premier(_ sender: Any) {
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "PremierChat") as! ChatViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
                
        ChatRoomSelect(room: "PremierLeague")
        
    }
    
    @IBAction func Laliga(_ sender: Any) {
        
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "LaligaChat") as! Chat2ViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        ChatRoomSelect(room: "LaLiga")
        
    }
    
    @IBAction func serieA(_ sender: Any) {
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "SerieAChat") as! Chat3ViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        ChatRoomSelect(room: "SerieA")
        
    }
    
    @IBAction func bundes(_ sender: Any) {
        
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "BundesChat") as! Chat4ViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        ChatRoomSelect(room: "BundesLiga")
        
    }
    
    @IBAction func CL(_ sender: Any) {
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "CLChat") as! Chat5ViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        ChatRoomSelect(room: "ChanpionsLegue")
    }
    
    private func ChatRoomSelect(room:String){
        
        let roomId = room
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let docData = ["createdAt":Timestamp(),"uid":uid] as [String : Any]
        Firestore.firestore().collection("chatRoom").document(roomId).setData(docData) { (err) in
            if let err = err{
                print("チャットルーム選択に失敗しました\(err)")
                return
            }
            print("チャットルーム選択に成功しました")
        }
        
    }
    
}
