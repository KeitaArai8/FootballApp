//
//  PracticeViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/22.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import SegementSlide
import Alamofire
import SwiftyJSON
import SDWebImage

class Page6ViewController: UITableViewController,SegementSlideContentScrollViewDelegate {
    
    //var newsItem = [JSONsoccer]()
    
    
    var titleArray = [String]()
    var publishAtArray = [String]()
    var imageURLStringArray = [String]()
    var JSONurlArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        getdata()
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        
        let profieleImageURL = URL(string: self.imageURLStringArray[indexPath.row] as String)!
        
        
        let imageSize = SDImageResizingTransformer(size: CGSize(width: 100, height: 80), scaleMode: .aspectFill)
        
        cell.imageView?.sd_setImage(with: profieleImageURL, placeholderImage: UIImage(named: "noImage"), options: .forceTransition, context: [.imageTransformer: imageSize], progress: nil, completed: { (_, error, _, _) in
            
            
            if error == nil{
                
                cell.setNeedsLayout()
                
            }
            
        })

        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.text = self.titleArray[indexPath.row]
        cell.detailTextLabel?.text = self.publishAtArray[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        
        
        return cell
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/7
    }

   

    func getdata(){
        
        let text = "https://newsapi.org/v2/everything?q=チャンピオンズリーグ CL&language=jp&sortBy=publishedAt&apiKey=1958c16c0cae44cf94156f4e04c2144d&pageSize=50"
        
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //リクエストを送る
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (responce) in
            
            //JSON解析
            switch responce.result{
                
            case.success:
                
                for i in 0...49{
                    
                    let json:JSON = JSON(responce.data as Any)
                    let publishedAt = json["articles"][i]["publishedAt"].string
                    let title = json["articles"][i]["title"].string
                    let imageURLString = json["articles"][i]["urlToImage"].string
                    let JSONurl = json["articles"][i]["url"].string
                    
                    self.publishAtArray.append(publishedAt!)
                    self.titleArray.append(title!)
                    self.JSONurlArray.append(JSONurl!)
                    
                    if imageURLString == "<null>"{
                        
                        self.imageURLStringArray.append("https://firebasestorage.googleapis.com/v0/b/footballapp2.appspot.com/o/noimage.png?alt=media&token=0d54a72d-e4ac-4f60-b22d-7f879a0b466b")
                        
                    }else if imageURLString == nil{
                        
                        self.imageURLStringArray.append("https://firebasestorage.googleapis.com/v0/b/footballapp2.appspot.com/o/noimage.png?alt=media&token=0d54a72d-e4ac-4f60-b22d-7f879a0b466b")
                        
                    }
                        
                    else{
                        self.imageURLStringArray.append(imageURLString!)
                    }
                    
                }
                
                break
            case.failure(let error):
                print(error)
                break
                
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let indexNumber = indexPath.row
        let webViewController = WebViewController()
        let url = JSONurlArray[indexNumber]
        webViewController.urlStirng = url
        
        webViewController.modalPresentationStyle = .currentContext
        present(webViewController,animated: true,completion: nil)

       }



    
    
}



