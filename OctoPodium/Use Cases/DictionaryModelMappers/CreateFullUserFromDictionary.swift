//
//  CreateFullUsersFromDictionary.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 08/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class CreateFullUserFromDictionary: CreateBasicUserFromDictionary {
    
    typealias RanksType = Array<Dictionary<String, AnyObject>>
    
    override init(userDic: NSDictionary) {
        super.init(userDic: userDic)
        buildUserFullInfo()
    }
    
    private func buildUserFullInfo() {
        user.city = (userDic["city"] ?? "") as? String
        user.country = (userDic["country"] ?? "") as? String
        
        user.rankings = buildRankings(userDic["rankings"] as! RanksType)
    }
    
    private func buildRankings(rankings: RanksType) -> [Ranking] {
        var ranks = [Ranking]()
        for rank in rankings {
            
            let city = (user.city ?? "")
            let cityTotal = (rank["city_count"] ?? 0) as? Int
            let cityRanking = (rank["city_rank"] ?? 0) as? Int
            
            let country = (user.country ?? "")
            let countryTotal = (rank["country_count"] ?? 0) as? Int
            let countryRanking = (rank["country_rank"] ?? 0) as? Int
            
            let worldTotal = (rank["world_count"] ?? 0) as? Int
            let worldRanking = (rank["world_rank"] ?? 0) as? Int
            
            let language = (rank["language"] ?? "") as? String
            let repositories = (rank["repository_count"] ?? 0) as? Int
            let stars = (rank["stars_count"] ?? 0) as? Int
            
            let ranking = Ranking(
                city: city,
                cityRanking: cityRanking,
                cityTotal: cityTotal,
                country: country,
                countryTotal: countryTotal,
                countryRanking: countryRanking,
                worldRanking: worldRanking,
                worldTotal: worldTotal,
                language: language,
                repositories: repositories,
                stars: stars)
            ranking.user = user
            ranks.append(ranking)
        }
        return ranks
    }
    
}