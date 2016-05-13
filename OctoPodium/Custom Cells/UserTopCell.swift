//
//  UserTopCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserTopCell : UITableViewCell, NibReusable {
    
    @IBOutlet weak var rankingImageView: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var avatarBackground: UIView!
    
    @IBOutlet weak var background: UIView!

    var userPresenter: UserPresenter? { didSet { self.fillDataFromPresenter() } }
    
    private func fillDataFromPresenter() {
        fillRankingInformation()
        login.text = userPresenter!.login()
        starsLabel.text = userPresenter!.stars()
        fillAvatar()
    }
    
    private func fillRankingInformation() {
        if userPresenter!.isPodiumRanking() {
            rankingImageView.image = UIImage(named: userPresenter!.rankingImageName()!)
        }
    }
    
    private func fillAvatar() {
        if let avatarUrl = userPresenter!.avatarUrl() {
            avatar.fetchAndLoad(avatarUrl)
        }
    }
}