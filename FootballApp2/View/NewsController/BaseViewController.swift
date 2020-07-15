//
//  ViewController.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/06/12.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit
import SegementSlide

class BaseViewController: SegementSlideDefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        defaultSelectedIndex = 0
        
//        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func segementSlideHeaderView() -> UIView? {
        
        
        let headerView = UIImageView()
        
        headerView.isUserInteractionEnabled = true
        
        headerView.contentMode = .scaleAspectFill
        
        headerView.image = UIImage(named: "header")
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerHeight: CGFloat
        
        headerHeight = view.bounds.height/4+view.safeAreaInsets.top
        
        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        
        return headerView
        
    }
    
    override var titlesInSwitcher: [String] {
        
        return ["TOP", "プレミアリーグ", "ラ・リーガ", "セリエA", "ブンデス","CL","Liverpool"]
        
    }
    
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        
        switch index {
            
        case 0:
            
            return Page1ViewController()
            
        case 1:
            
            return Page2ViewController()
            
        case 2:
            
            return Page3ViewController()
            
        case 3:
            
            return Page4ViewController()
            
        case 4:
            
            return Page5ViewController()
        case 5:
            
            return Page6ViewController()
        case 6:
            
            return Page7ViewController()
            
        default:
            
            return Page1ViewController()
            
        }
        
    }



}

