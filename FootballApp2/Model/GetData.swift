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

protocol getDataDelegate {
    func getDataArray(titleArray:[String], publishAtArray:[String], imageURLStringArray:[String], JSONurlArray:[String])
}


class GetData {
    
    var delegate:getDataDelegate?
    
    func getdata(text:String) {
        
        
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //リクエストを送る
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (responce) in
            NewsModel.publishAtArray = []
            NewsModel.titleArray = []
            NewsModel.JSONurlArray  = []
            NewsModel.imageURLStringArray = []
            
            
            //JSON解析
            switch responce.result{
                
            case.success:
                
                for i in 0...49{
                    
                    let json:JSON = JSON(responce.data as Any)
                    let publishedAt = json["articles"][i]["publishedAt"].string
                    let title = json["articles"][i]["title"].string
                    let imageURLString = json["articles"][i]["urlToImage"].string
                    let JSONurl = json["articles"][i]["url"].string
                    
                    NewsModel.publishAtArray.append(publishedAt!)
                    NewsModel.titleArray.append(title!)
                    NewsModel.JSONurlArray.append(JSONurl!)
                    
                    if imageURLString == "<null>"{
                        
                        NewsModel.imageURLStringArray.append("https://firebasestorage.googleapis.com/v0/b/footballapp2.appspot.com/o/noimage.png?alt=media&token=0d54a72d-e4ac-4f60-b22d-7f879a0b466b")
                        
                    }else if imageURLString == nil{
                        
                        NewsModel.imageURLStringArray.append("https://firebasestorage.googleapis.com/v0/b/footballapp2.appspot.com/o/noimage.png?alt=media&token=0d54a72d-e4ac-4f60-b22d-7f879a0b466b")
                        
                    }
                        
                    else{
                        NewsModel.imageURLStringArray.append(imageURLString!)
                    }
                    
                }
                self.delegate?.getDataArray(titleArray: NewsModel.titleArray, publishAtArray: NewsModel.publishAtArray, imageURLStringArray: NewsModel.imageURLStringArray, JSONurlArray: NewsModel.JSONurlArray)
                break
            case.failure(let error):
                print(error)
                break
                
            }
            
            
        }
        
    }
    
}

