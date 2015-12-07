//
//  UserTopCell.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 07/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserTopCell : UITableViewCell {
    
    @IBOutlet weak var rankingImageView: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var background: UIView!
    
    let positionColors: [UInt] = [K.firstInRankingColor, K.secondInRankingColor, K.thirdnRankingColor]
    
    var position: Int? {
        didSet {
            if position < 4 && position > 0 {
                rankingImageView.image = UIImage(named: "\(position!).png")
                let color = UIColor.fromHex(positionColors[position! - 1])
                background.backgroundColor = color
            }
        }
    }
    
    var user: User! {
        didSet {
            login.text = user.login
            if let avatarUrl = user.avatarUrl {
                ImageLoader.fetchAndLoad(avatarUrl, imageView: avatar)
            }
        }
    }
}