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
    @IBOutlet weak var avatarBackground: UIView!
    
    @IBOutlet weak var background: UIView!

    var userPresenter: UserPresenter? { didSet { self.fillDataFromPresenter() } }
    
    private func fillDataFromPresenter() {
        fillRankingInformation()
        login.text = userPresenter!.login()
        fillAvatar()
    }
    
    private func fillRankingInformation() {
        if userPresenter!.isPodiumRanking() {
            rankingImageView.image = UIImage(named: userPresenter!.rankingImageName())
            background.backgroundColor = UIColor(rgbValue: userPresenter!.backgroundColor()!)
            avatarBackground.backgroundColor = UIColor(rgbValue: userPresenter!.avatarBackgroundColor()!)
        }
    }
    
    private func fillAvatar() {
        if let avatarUrl = userPresenter!.avatarUrl() {
            ImageLoader.fetchAndLoad(avatarUrl, imageView: avatar)
        }
    }
}