//
//  GetData.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/11.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetData {
    
    
    var titleArray = [String]()
    var publishAtArray = [String]()
    var imageURLStringArray = [String]()
    var JSONurlArray = [String]()
    
    
    
    func getdata(text:String){
        
        let text = ""
        
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
            
//            self.tableView.reloadData()
            
        }
        
    }
    
}

