//
//  RankingCell.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityRankingLabel: UILabel!
    @IBOutlet weak var countryRankingLabel: UILabel!
    @IBOutlet weak var worldRankingLabel: UILabel!
    @IBOutlet weak var reposLabel: UILabel!
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
    }

    private func fillLangReposAndStars(rankingPresenter: RankingPresenter) {
        languageLabel.text = rankingPresenter.language
        reposLabel.text = rankingPresenter.repositories
        starsLabel.text = rankingPresenter.stars
    }
    
    private func fillCityLabels(rankingPresenter: RankingPresenter) {
        cityNameLabel.text = rankingPresenter.city
        cityRankingLabel.text = rankingPresenter.rankingForCity
        cityTrophyImage.image = UIImage(named: rankingPresenter.cityRankingImage)
    }
    
    private func fillCountryLabels(rankingPresenter: RankingPresenter) {
        countryNameLabel.text = rankingPresenter.country
        countryRankingLabel.text = rankingPresenter.rankingForCountry
        countryTrophyImage.image = UIImage(named: rankingPresenter.countryRankingImage)
    }
    
    private func fillWorldLabels(rankingPresenter: RankingPresenter) {
        worldRankingLabel.text = rankingPresenter.rankingForWorld
        worldTrophyImage.image = UIImage(named: rankingPresenter.worldRankingImage)
    }

    
    private func showUserLanguageReposInBrowser() {
        guard let rankingPresenter = rankingPresenter else { return }
        let url = NSURL(string: "https://github.com/search?q=user:\(rankingPresenter.userLogin)+language:\(rankingPresenter.language)")
        UIApplication.sharedApplication().openURL(url!)
    }
}
