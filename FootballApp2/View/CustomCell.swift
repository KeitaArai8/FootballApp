//
//  CustomCell.swift
//  FootballApp2
//
//  Created by Keita Arai on 2020/07/02.
//  Copyright © 2020 Keita Arai. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var user: User?
    
    var comment:Comment?{
        didSet{
            if let comment = comment{
                commentLabel.text = comment.comment
                
                dateLabel.text = dateFormatter(date: comment.createdAt.dateValue())
            }
        }
        
    }
    
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        commentLabel.layer.cornerRadius = 10
        commentLabel.font = UIFont.boldSystemFont(ofSize: 18)
        commentLabel.clipsToBounds = true
        commentLabel.backgroundColor = .white
        commentLabel.numberOfLines = 0
        commentLabel.sizeToFit()
        backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func dateFormatter(date:Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)

   }
    
}
