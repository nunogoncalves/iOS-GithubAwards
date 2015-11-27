//
//  User.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class User {
    var login: String?
    var avatarUrl: String?
    
    var rankings = [
        Ranking(city: "Lisbon", cityRanking: 1, cityTotal: 42, country: "Portugal", countryTotal: 123, countryRanking: 2, worldRanking: 3, worldTotal: 120220, language: "Swift", repositories: 2, stars: 435),
        Ranking(city: "Lisbon", cityRanking: 2, cityTotal: 42, country: "Portugal", countryTotal: 234, countryRanking: 45, worldRanking: 5434, worldTotal: 232432, language: "Ruby", repositories: 56, stars: 12),
        Ranking(city: "Lisbon", cityRanking: 3, cityTotal: 42, country: "Portugal", countryTotal: 121, countryRanking: 45, worldRanking: 5434, worldTotal: 120220, language: "JavaScript", repositories: 1, stars: 21),
        Ranking(city: "Lisbon", cityRanking: 4, cityTotal: 42, country: "Portugal", countryTotal: 1, countryRanking: 45, worldRanking: 5434, worldTotal: 120220, language: "Java", repositories: 54, stars: 876),
        Ranking(city: "Lisbon", cityRanking: 3, cityTotal: 42, country: "Portugal", countryTotal: 65, countryRanking: 45, worldRanking: 5434, worldTotal: 120220, language: "ObjectiveC", repositories: 1, stars: 3),
        Ranking(city: "Lisbon", cityRanking: 132, cityTotal: 42, country: "Portugal", countryTotal: 443, countryRanking: 45, worldRanking: 5434, worldTotal: 120220, language: "Scala", repositories: 4, stars: 0),
        Ranking(city: "Lisbon", cityRanking: 1, cityTotal: 42, country: "Portugal", countryTotal: 3433, countryRanking: 45, worldRanking: 5434, worldTotal: 120220, language: ".Net", repositories: 3, stars: 1),
        Ranking(city: "Lisbon", cityRanking: 3, cityTotal: 42, country: "Portugal", countryTotal: 3423, countryRanking: 45, worldRanking: 5434, worldTotal: 120220, language: "Pearl", repositories: 7, stars: 0),
        Ranking(city: "Lisbon", cityRanking: 2, cityTotal: 42, country: "Portugal", countryTotal: 1235433, countryRanking: 45, worldRanking: 23423, worldTotal: 120220, language: "PHP", repositories: 9, stars: 0),
    ]
    
    init(login: String, avatarUrl: String) {
        self.login = login
        self.avatarUrl = avatarUrl
    }
}
