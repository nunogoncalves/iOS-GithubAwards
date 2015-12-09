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
        guard let user = user, let language = ranking?.language else { return }
        let url = NSURL(string: "https://github.com/search?q=user:\(user.login!)+language:\(language)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    let throphies = [
        1: UIImage(named: "GoldTrophy"),
        2: UIImage(named: "SilverTrophy"),
        3: UIImage(named: "BronzeTrophy"),
        4: UIImage(named: "Trophy")
    ]
    
    var user: User?
    
    var ranking: Ranking? {
        didSet {
            guard let ranking = ranking else {
                return
            }
            languageLabel.text = ranking.language ?? ""
            cityNameLabel.text = ranking.city ?? ""
            setRankingsIn(cityRankingLabel, userRanking: ranking.cityRanking, locationRanking: ranking.cityTotal, rankingImage: cityTrophyImage)
            countryNameLabel.text = ranking.country ?? ""
            setRankingsIn(countryRankingLabel, userRanking: ranking.countryRanking, locationRanking: ranking.countryTotal, rankingImage: countryTrophyImage)
            setRankingsIn(worldRankingLabel, userRanking: ranking.worldRanking, locationRanking: ranking.worldTotal, rankingImage: worldTrophyImage)
 
            let repos = ranking.repositories ?? 0
            reposLabel.text = "\(repos)"
            
            let stars = ranking.stars ?? 0
            starsLabel.text = "\(stars)"
            
        }
    }
    
    private func setRankingsIn(label: UILabel, userRanking: Int?, locationRanking: Int?, rankingImage: UIImageView) {
        if userRanking != nil && locationRanking != nil {
            label.text = "\(userRanking!)/\(locationRanking!)"
            let throphyIndex = userRanking! < 4 ? userRanking! : 4
            rankingImage.image = throphies[throphyIndex]!
        } else {
            label.text = "-/-"
        }
    }

}
