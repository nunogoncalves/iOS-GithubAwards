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
        return rankings.compactMap(self.ranking(from:))
    }

    private func ranking(from json: JSON) -> Ranking? {

        guard
            let language = (json["language"] as? String),
            !language.isEmpty,
            let repositories = (json["repository_count"] as? Int),
            let stars = (json["stars_count"] as? Int)
        else {
            return nil
        }

        return Ranking(
            world: worldRanking(from: json),
            country: countryRanking(from: json),
            city: cityRanking(from: json),
            language: "\(language)",
            repositories: repositories,
            stars: stars
        )
    }

    private func worldRanking(from json: JSON) -> WorldRanking {
        let total = json["world_count"] as! Int
        let ranking = json["world_rank"] as! Int

        return WorldRanking(position: ranking, total: total)
    }

    private func countryRanking(from json: JSON) -> CountryRanking? {
        guard let name = user.country?.capitalized, !name.isEmpty,
            let total = json["country_count"] as? Int,
            let ranking = json["country_rank"] as? Int
        else {
            return nil
        }
        return CountryRanking(name: name, position: ranking, total: total)
    }

    private func cityRanking(from json: JSON) -> CityRanking? {
        guard let name = user.city?.capitalized, !name.isEmpty,
            let total = json["city_count"] as? Int,
            let ranking = json["city_rank"] as? Int
        else {
            return nil
        }
        return CountryRanking(name: name, position: ranking, total: total)
    }
}
