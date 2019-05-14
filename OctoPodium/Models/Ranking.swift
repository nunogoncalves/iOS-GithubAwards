//
//  Ranking.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

protocol RankingProtocol {
    var position: Int { get }
    var total: Int { get }
}

extension RankingProtocol {
    @available(*, deprecated, message: "to be removed")
    var rank: Int { return position }

    var description: String {
        guard position > 0 && total > 0 else { return "-/-" }
        return "\(position)/\(total)"
    }
}

struct WorldRanking: RankingProtocol {
    let position: Int
    let total: Int
}

struct LocationRanking: RankingProtocol {
    let name: String
    let position: Int
    let total: Int
}

typealias CityRanking = LocationRanking
typealias CountryRanking = LocationRanking

class Ranking {
    
    weak var user: User?

    var world: WorldRanking
    var country: CountryRanking?
    var city: CityRanking?

    var language: String?
    var repositories: Int?
    var stars: Int
    
    init(
        world: WorldRanking,
        country: CountryRanking?,
        city: CityRanking?,
        language: String?, 
        repositories: Int?, 
        stars: Int?
    ) {
        
        self.city = city
        self.country = country
        self.world = world
        self.language = language
        self.repositories = repositories
        self.stars = stars ?? 0
    }
    
    var trophies: Int {
        return [world.rank, city?.rank, country?.rank].count { $0?.inPodium == true }
    }
}

private extension Int {
    var inPodium: Bool { return self < 4 && self > 0 }
}
