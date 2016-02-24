//
//  Builder.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

@testable import OctoPodium

class TestsBuilder {
    
    static func buildRankingWith(
        cityRanking: Int?,
        countryRanking: Int?,
        worldRanking: Int?) -> Ranking {
        
        let ranking = Ranking(city: "",
            cityRanking: cityRanking,
            cityTotal: 123,
            country: "",
            countryTotal: 1000,
            countryRanking: countryRanking,
            worldRanking: worldRanking,
            worldTotal: 1000,
            language: "",
            repositories: 123, stars: 1234)
        return ranking
    }
    
}
