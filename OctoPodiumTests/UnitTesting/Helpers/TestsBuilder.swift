//
//  Builder.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

@testable import OctoPodium

struct TestsBuilder {
    
    static func buildRankingWith(
        cityRanking: Int?,
        countryRanking: Int?,
        worldRanking: Int
    ) -> Ranking {

        return Ranking(
            world: WorldRanking(position: worldRanking, total: 1000),
            country: countryRanking != nil ? CountryRanking(name: "", position: countryRanking!, total: 1000) : nil,
            city: cityRanking != nil ? CityRanking(name: "", position: cityRanking!, total: 123) : nil,
            language: "",
            repositories: 123,
            stars: 1234
        )
    }    
}
