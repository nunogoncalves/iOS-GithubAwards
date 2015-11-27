//
//  Ranking.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 24/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class Ranking {
    
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
    var stars: Int?
    
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
            self.stars = stars
    }
}
