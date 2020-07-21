//
//  PracticeViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/22.
//  Copyright © 2020 Keita Arai. All rights reserved.


import UIKit
import SegementSlide
import Alamofire
import SwiftyJSON
import SDWebImage
import Firebase


class Page6ViewController: UITableViewController,SegementSlideContentScrollViewDelegate,getDataDelegate {
    
    var getdataClass = GetData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        getdataClass.getdata(text: "https://newsapi.org/v2/everything?q=チャンピオンズリーグ CL&language=jp&sortBy=publishedAt&apiKey=1958c16c0cae44cf94156f4e04c2144d&pageSize=50")
        getDataArray(titleArray: NewsModel.titleArray, publishAtArray: NewsModel.publishAtArray, imageURLStringArray: NewsModel.imageURLStringArray, JSONurlArray: NewsModel.JSONurlArray)
        
    }
    
    func getDataArray(titleArray: [String], publishAtArray: [String], imageURLStringArray: [String], JSONurlArray: [String]) {
        
        NewsModel.titleArray = titleArray
        NewsModel.publishAtArray = publishAtArray
        NewsModel.imageURLStringArray = imageURLStringArray
        NewsModel.JSONurlArray = JSONurlArray
        getdataClass.delegate = self
        
        self.tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return NewsModel.titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        
        let profieleImageURL = URL(string: NewsModel.imageURLStringArray[indexPath.row] as String)!
        
        
        let imageSize = SDImageResizingTransformer(size: CGSize(width: 100, height: 80), scaleMode: .aspectFill)
        
        cell.imageView?.sd_setImage(with: profieleImageURL, placeholderImage: UIImage(named: "noImage"), options: .forceTransition, context: [.imageTransformer: imageSize], progress: nil, completed: { (_, error, _, _) in
            
            
            if error == nil{
                
                cell.setNeedsLayout()
                
            }
            
        })
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.text = NewsModel.titleArray[indexPath.row]
        cell.detailTextLabel?.text = NewsModel.publishAtArray[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexNumber = indexPath.row
        let webViewController = WebViewController()
        let url = NewsModel.JSONurlArray[indexNumber]
        webViewController.urlStirng = url
        
        webViewController.modalPresentationStyle = .currentContext
        present(webViewController,animated: true,completion: nil)
        
    }
}






