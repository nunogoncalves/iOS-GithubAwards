//
//  TopUserPresenter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class UserPresenter {
    
    let user: User
    let ranking: Int
    
    let totalRepositories: Int
    let totalStars: Int
    let totalTrophies: Int
    
    private let medalImages = ["GoldMedal", "SilverMedal", "BronzeMedal"]
    
    private let positionColors: [UIColor] = [
        .firstInRankingColor,
        .secondInRankingColor,
        .thirdInRankingColor
    ]
    
    private let avatarBGColors: [UIColor] = [
        .secondInRankingColor,
        .thirdInRankingColor,
        UIColor(hex: 0xE5E5FF)
    ]
    
    init(user: User, ranking: Int) {
        self.user = user
        self.ranking = ranking
        
        let reposStarsTrophies = UserPresenter.reposStarsAndTrophiesFrom(user)
        totalRepositories = reposStarsTrophies.repos
        totalStars = reposStarsTrophies.stars
        totalTrophies = reposStarsTrophies.trophies
    }
    
    private static func reposStarsAndTrophiesFrom(_ user: User) -> (repos: Int, stars: Int, trophies: Int) {
        let initialTuple = (repos: 0, stars: 0, trophies: 0)
        
        return user.rankings.reduce(initialTuple) { (tuple, ranking) -> (repos: Int, stars: Int, trophies: Int) in
            let repos = tuple.repos + (ranking.repositories ?? 0)
            let stars = tuple.stars + (ranking.stars)
            let trophies = tuple.trophies + ranking.trophies
            return (repos: repos, stars: stars, trophies: trophies)
        }
    }
    
    convenience init(user: User) {
        var ranking = 0
        if user.rankings.count > 0 {
            let topRanking = user.rankings[0]
            ranking = topRanking.city?.position ?? (topRanking.country?.position ?? topRanking.world.position)
        }
        self.init(user: user, ranking: ranking)
    }
    
    var isInPodium: Bool {
        return ranking < 4 && ranking > 0
    }

    var rankingImageName: String? {
        if isInPodium {
            return medalImages[ranking - 1]
        }
        return nil
    }
    
    func backgroundColor() -> UIColor? {
        if isInPodium {
            return positionColors[ranking - 1]
        }
        return nil
    }
    
    func avatarBackgroundColor() -> UIColor? {
        if isInPodium {
            return avatarBGColors[ranking - 1]
        }
        return nil
    }
    
    var login: String {
        return user.login
    }
    
    var avatarUrl: String? {
        return user.avatarUrl
    }
    
    var stars: String {
        return "\(user.starsCount ?? 0)"
    }

    var calculatedStars: String {
        let number = user.rankings.reduce(0) { (value, ranking) -> Int in
            return value + ranking.stars
        }

        return "\(number)"
    }

    var hasLocation: Bool {
        return user.hasLocation
    }
    
    var locationName: String {
        if let city = user.city { return city }
        if let country = user.country { return country }
        return "the world"
    }
    
    var fullLocation: String {
        let city = user.city?.capitalized
        let country = user.country?.capitalized
        return String.join(", ", country, city)
    }
    
    var gitHubUrl: String {
        return "https://www.github.com/\(user.login)"
    }

    var rankingInfo: (repositories: Int?, stars: Int?, languages: Int?, medals: Int?) {
        return (repositories: totalRepositories, stars: totalStars, languages: user.rankings.count, medals: totalTrophies)
    }
}
