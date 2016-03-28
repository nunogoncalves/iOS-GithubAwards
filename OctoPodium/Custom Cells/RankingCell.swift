//
//  RankingCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell, NibReusable {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var medalOne: UIImageView!
    @IBOutlet weak var medalTwo: UIImageView!
    @IBOutlet weak var medalThree: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityRankingLabel: UILabel!
    @IBOutlet weak var cityTotalLabel: UILabel!

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryRankingLabel: UILabel!
    @IBOutlet weak var countryTotalLabel: UILabel!
    
    @IBOutlet weak var worldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var worldRankingLabel: UILabel!
    @IBOutlet weak var worldTotalLabel: UILabel!
    
    @IBOutlet weak var reposNameLabel: UILabel!
    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var reposImageView: UIImageView!
    
    @IBOutlet weak var starsNameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!
    
    var rankingPresenter: RankingPresenter? {
        didSet {
            fillCell()
        }
    }

    var visibleMedals = 0
    
    let medalsVsSpace = [
        0: CGFloat(10),
        1: CGFloat(46),
        2: CGFloat(55),
        3: CGFloat(64),
    ]
    
    private func fillCell() {
        guard let rankingPresenter = rankingPresenter else {
            return
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "showUserLanguageReposInBrowser")
        header.addGestureRecognizer(tapGesture)
        
        if rankingPresenter.country == "" {
            worldTopConstraint.constant = 5
            contentView.layoutIfNeeded()
        }
        
        if rankingPresenter.hasMedals() {
            medalOne.hide()
            medalTwo.hide()
            medalThree.hide()
            let howMany = rankingPresenter.howManyDifferentMedals()
            languageLeadingConstraint.constant = medalsVsSpace[howMany]!
            let medals = [medalOne, medalTwo, medalThree]
            var goldAlready = false
            var siverAlready = false
            for i in (0...howMany - 1) {
                if rankingPresenter.hasGoldMedal() && !goldAlready {
                    goldAlready = true
                    medals[i].image = UIImage(named: "GoldMedal")
                    medals[i].show()
                    continue
                }
                if rankingPresenter.hasSilverMedal() && !siverAlready {
                    siverAlready = true
                    medals[i].image = UIImage(named: "SilverMedal")
                    medals[i].show()
                    continue
                }
                if rankingPresenter.hasBronzeMedal() {
                    medals[i].image = UIImage(named: "BronzeMedal")
                    medals[i].show()
                    continue
                }
            }
        } else {
            languageLeadingConstraint.constant = 10
            medalOne.hide()
            medalTwo.hide()
            medalThree.hide()
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
        if rankingPresenter.city == "" {
            cityNameLabel.text =  "city"
        }
        
        cityRankingLabel.text = "\(rankingPresenter.cityRanking)"
        cityTotalLabel.text = "/\(rankingPresenter.cityTotal)"
    }
    
    private func fillCountryLabels(rankingPresenter: RankingPresenter) {
        countryNameLabel.text = rankingPresenter.country
        countryRankingLabel.text = "\(rankingPresenter.countryRanking)"
        countryTotalLabel.text = "/\(rankingPresenter.countryTotal)"
    }
    
    private func fillWorldLabels(rankingPresenter: RankingPresenter) {
        worldRankingLabel.text = "\(rankingPresenter.worldRanking)"
        worldTotalLabel.text = "/\(rankingPresenter.worldTotal)"
    }

    private func paintHeader(rankingPresenter: RankingPresenter) {
        header.backgroundColor = UIColor(rgbValue: rankingPresenter.headerColorHex())
        let textColor = rankingPresenter.textColor()
        starsImageView.image = UIImage(named: rankingPresenter.starImage())
        reposImageView.image = UIImage(named: rankingPresenter.repoImage())
        languageLabel.textColor = UIColor(rgbValue: textColor)
        reposLabel.textColor = UIColor(rgbValue: textColor)
        starsLabel.textColor = UIColor(rgbValue: textColor)
    }
    
    @objc private func showUserLanguageReposInBrowser() {
        guard let rankingPresenter = rankingPresenter else { return }
        Browser.openPage("https://github.com/search?q=user:\(rankingPresenter.userLogin)+language:\(rankingPresenter.language)")
        Analytics.SendToGoogle.viewUserLanguagesOnGithub(rankingPresenter.userLogin, language: rankingPresenter.language)
    }
}
