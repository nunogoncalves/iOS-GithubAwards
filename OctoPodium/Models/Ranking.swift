//
//  Ranking.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class Ranking {
    
    weak var user: User?
    
    var city: String?
    var cityRanking: Int?
    var cityTotal: Int?
    var country: String?
    var countryTotal: Int?
    var countryRanking: Int?
    var worldRanking: Int?
    var worldTotal: Int?
    
    var language: String?
    var repositories: Int?
    var stars: Int
    
    init(city: String?,
        cityRanking: Int?,
        cityTotal: Int?,
        country: String?,
        countryTotal: Int?,
        countryRanking: Int?,
        worldRanking: Int?,
        worldTotal: Int?,
        language: String?, 
        repositories: Int?, 
        stars: Int?) {
        
            self.city = city
            self.cityRanking = cityRanking
            self.cityTotal = cityTotal
            self.country = country
            self.countryTotal = countryTotal
            self.countryRanking = countryRanking
            self.worldRanking = worldRanking
            self.worldTotal = worldTotal
            self.language = language
            self.repositories = repositories
            self.stars = stars ?? 0
    }
    
    var trophies: Int {
        return (isPodium(worldRanking) ? 1 : 0) + (isPodium(cityRanking) ? 1 : 0) + (isPodium(countryRanking) ? 1 : 0)
    }
        
    private func isPodium(rank: Int?) -> Bool {
        return rank?.belongsInPodium() ?? false
    }
}

private extension Int {
    func belongsInPodium() -> Bool { return self < 4 && self > 0 }
}
