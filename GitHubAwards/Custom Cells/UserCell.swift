//  UserCell.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var positionLabel: UILabel!

    var position: Int? {
        didSet {
            positionLabel.text = "\(position!)"
        }
    }
    
    var bgColor: UIColor? {
        didSet {
            background.backgroundColor = bgColor!
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
