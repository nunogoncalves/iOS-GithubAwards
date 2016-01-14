//
//  RankingCell.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityRankingLabel: UILabel!
    @IBOutlet weak var cityTotalLabel: UILabel!

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryRankingLabel: UILabel!
    @IBOutlet weak var countryTotalLabel: UILabel!
    
    @IBOutlet weak var worldRankingLabel: UILabel!
    @IBOutlet weak var worldTotalLabel: UILabel!
    
    @IBOutlet weak var reposNameLabel: UILabel!
    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var starsNameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    
    @IBOutlet weak var cityTrophyImage: UIImageView!
    @IBOutlet weak var countryTrophyImage: UIImageView!
    @IBOutlet weak var worldTrophyImage: UIImageView!
    
    @IBAction func languageClicked() {
        showUserLanguageReposInBrowser()
    }
    
    var rankingPresenter: RankingPresenter? {
        didSet {
            fillCell()
        }
    }
    
    private func fillCell() {
        guard let rankingPresenter = rankingPresenter else {
            return
        }
        
        fillLangReposAndStars(rankingPresenter)
        fillCityLabels(rankingPresenter)
        fillCountryLabels(rankingPresenter)
        fillWorldLabels(rankingPresenter)
        
        paintHeader(rankingPresenter)
    }

    private func fillLangReposAndStars(rankingPresenter: RankingPresenter) {
        languageLabel.text = rankingPresenter.language
        reposLabel.text = rankingPresenter.repositories
        starsLabel.text = rankingPresenter.stars
    }
    
    private func fillCityLabels(rankingPresenter: RankingPresenter) {
        cityNameLabel.text = rankingPresenter.city
        cityRankingLabel.text = "\(rankingPresenter.cityRanking)"
        cityTotalLabel.text = "/\(rankingPresenter.cityTotal)"
        
        cityTrophyImage.image = UIImage(named: rankingPresenter.cityRankingImage)
    }
    
    private func fillCountryLabels(rankingPresenter: RankingPresenter) {
        countryNameLabel.text = rankingPresenter.country
        countryRankingLabel.text = "\(rankingPresenter.countryRanking)"
        countryTotalLabel.text = "/\(rankingPresenter.countryTotal)"
        countryTrophyImage.image = UIImage(named: rankingPresenter.countryRankingImage)
    }
    
    private func fillWorldLabels(rankingPresenter: RankingPresenter) {
        worldRankingLabel.text = "\(rankingPresenter.worldRanking)"
        worldTotalLabel.text = "/\(rankingPresenter.worldTotal)"
        worldTrophyImage.image = UIImage(named: rankingPresenter.worldRankingImage)
    }

    private func paintHeader(rankingPresenter: RankingPresenter) {
        header.backgroundColor = UIColor(rgbValue: rankingPresenter.headerColorHex())
        let textColor = rankingPresenter.textColor()
        languageLabel.textColor = UIColor(rgbValue: textColor)
        reposNameLabel.textColor = UIColor(rgbValue: textColor)
        reposLabel.textColor = UIColor(rgbValue: textColor)
        starsNameLabel.textColor = UIColor(rgbValue: textColor)
        starsLabel.textColor = UIColor(rgbValue: textColor)
    }
    
    private func showUserLanguageReposInBrowser() {
        guard let rankingPresenter = rankingPresenter else { return }
        let url = NSURL(string: "https://github.com/search?q=user:\(rankingPresenter.userLogin)+language:\(rankingPresenter.language)")
        UIApplication.sharedApplication().openURL(url!)
    }
}
