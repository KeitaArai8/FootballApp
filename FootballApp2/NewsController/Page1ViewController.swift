

import UIKit
import SegementSlide

class Page1ViewController: UITableViewController,SegementSlideContentScrollViewDelegate,XMLParserDelegate {
    
    var titlesInSegementSlideSwitcherView: [String] = []
    
    var parser = XMLParser()
    var parseName:String!
    
    var newsItem = [News]()
    var item:News?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startDownload()
        
    }
    
    func startDownload() {
        self.newsItem = []
        if let url = URL(
            string: "https://news.google.com/rss/search?q=soccer&hl=ja&gl=JP&ceid=JP:ja"){
            if let parser = XMLParser(contentsOf: url){
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        return newsItem.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = newsItem[indexPath.row].title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = .black
        cell.textLabel?.numberOfLines = 3
        
        cell.detailTextLabel?.text = newsItem[indexPath.row].pubDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/6
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        self.parseName = ""
        if elementName == "item"{
            
            self.item = News()
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        self.parseName += string
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case "title":
            self.item?.title = parseName
        case "link":
            self.item?.url = parseName
        case "pubDate":
            self.item?.pubDate = parseName
        case "item" :
            self.newsItem.append(self.item!)
        default:
            break
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webViewController = WebViewController()
        webViewController.modalPresentationStyle = .currentContext
        let newsItems = newsItem[indexPath.row]
        let url = newsItems.url
        webViewController.urlStirng = url
        present(webViewController,animated: true,completion: nil)
        
    }
    
    
}
