

import UIKit
import WebKit

class ScheduleViewController: UIViewController,WKUIDelegate {
    
    var webView = WKWebView()
    var activityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var premier: UIButton!
    @IBOutlet weak var laliga: UIButton!
    @IBOutlet weak var serieA: UIButton!
    @IBOutlet weak var bundes: UIButton!
    @IBOutlet weak var CLbutton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        premier.setImage(UIImage(named: "premier2"), for: UIControl.State.normal)
        laliga.setImage(UIImage(named: "LaLiga"), for: UIControl.State.normal)
        serieA.setImage(UIImage(named: "serieA"), for: UIControl.State.normal)
        bundes.setImage(UIImage(named: "bundes"), for: UIControl.State.normal)
        CLbutton.setImage(UIImage(named: "CL"), for: UIControl.State.normal)
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func premier(_ sender: Any) {
        
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        let urlString = "https://www.google.com/search?q=%E3%83%97%E3%83%AC%E3%83%9F%E3%82%A2%E3%83%AA%E3%83%BC%E3%82%B0&rlz=1C5CHFA_enJP900JP900&aqs=chrome..69i57j0l7.5212j1j8&sourceid=chrome&ie=UTF-8#sie=lg;/g/11fj6snmjm;2;/m/02_tc;mt;fp;1;;"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        Indicator()
    }
    
    @IBAction func LaLiga(_ sender: Any) {
        
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        let urlString = "https://www.google.com/search?q=laliga&rlz=1C5CHFA_enJP900JP900&oq=laliga&aqs=chrome..69i57j0l7.9402j0j7&sourceid=chrome&ie=UTF-8#sie=lg;/g/11ff1xzn64;2;/m/09gqx;mt;fp;1;;"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        Indicator()
    }
    
    @IBAction func serieA(_ sender: Any) {
        
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        let urlString = "https://www.google.com/search?rlz=1C5CHFA_enJP900JP900&ei=9VPvXrv2JtXW-Qb58bfYAw&q=serie+a&oq=seri&gs_lcp=CgZwc3ktYWIQARgAMgwIABCDARBDEEYQ_QEyBAgAEEMyBAgAEEMyBAgAEEMyBAgAEEMyBwgAEIMBEAQyBQgAEIMBMgUIABCDAToHCAAQgwEQQzoCCAA6BQgAELEDOgQIABAEOgkIABBDEEYQ_QFQ2IYDWK6ZA2D_pgNoAXAAeAGAAWeIAZ4GkgEDNy4ymAEAoAEBqgEHZ3dzLXdperABAA&sclient=psy-ab#sie=lg;/g/11h02jy6ph;2;/m/03zv9;mt;fp;1;;"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        Indicator()
    }
    
    
    @IBAction func bundesliga(_ sender: Any) {
        
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        let urlString = "https://www.google.com/search?q=Bundesliga&rlz=1C5CHFA_enJP900JP900&oq=Bundesliga&aqs=chrome..69i57j0l7.1676j0j8&sourceid=chrome&ie=UTF-8#sie=lg;/g/11fk0cxp0k;2;/m/037169;mt;fp;1;;"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        Indicator()
    }
    
    
    @IBAction func CL(_ sender: Any) {
        
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        let urlString = "https://www.uefa.com/uefachampionsleague/fixtures-results/#/rd/2001141/2"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        Indicator()
    }
    
    
    private func Indicator(){
        
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
        view.addSubview(activityIndicatorView)
        
    }
    
    
    
}
