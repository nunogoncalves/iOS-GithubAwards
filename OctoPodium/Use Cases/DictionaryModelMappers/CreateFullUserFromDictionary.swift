//
//  CreateFullUsersFromDictionary.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 08/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class CreateFullUserFromDictionary: CreateBasicUserFromDictionary {
    
    typealias RanksType = [JSON]
    
    override init(from json: JSON) {
        super.init(from: json)
        buildUserFullInfo()
    }
    
    private func buildUserFullInfo() {
        user.city = (json["city"] ?? "") as? String
        user.country = (json["country"] ?? "") as? String
        
        user.rankings = buildRankings(json["rankings"] as! RanksType)
    }
    
    private func buildRankings(_ rankings: RanksType) -> [Ranking] {
        var ranks = [Ranking]()
        for rank in rankings {
            let city = (user.city ?? "")
            let cityTotal = (rank["city_count"] as? Int) ?? 0
            let cityRanking = (rank["city_rank"] as? Int) ?? 0
            
            let country = (user.country ?? "")
            let countryTotal = (rank["country_count"] as? Int) ?? 0
            let countryRanking = (rank["country_rank"] as? Int) ?? 0
            
            let worldTotal = (rank["world_count"] as? Int) ?? 0
            let worldRanking = (rank["world_rank"] as? Int) ?? 0
            
            let language = (rank["language"] as? String) ?? ""
            let repositories = (rank["repository_count"] as? Int) ?? 0
            let stars = (rank["stars_count"] as? Int) ?? 0
            
            let ranking = Ranking(
                city: city,
                cityRanking: cityRanking,
                cityTotal: cityTotal,
                country: country,
                countryTotal: countryTotal,
                countryRanking: countryRanking,
                worldRanking: worldRanking,
                worldTotal: worldTotal,
                language: "\(language)",
                repositories: repositories,
                stars: stars)
            ranking.user = user
            ranks.append(ranking)
        }
        return ranks
    }
    
}
