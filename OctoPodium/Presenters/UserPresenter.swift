//
//  TopUserPresenter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

protocol TopUserView {
    
}

class UserPresenter {
    
    let user: User
    let ranking: Int
    
    private let medalImages = ["GoldMedal", "SilverMedal", "BronzeMedal"]
    
    private let positionColors: [UInt] = [
        kColors.firstInRankingColor,
        kColors.secondInRankingColor,
        kColors.thirdInRankingColor
    ]
    
    private let avatarBGColors: [UInt] = [
        kColors.secondInRankingColor,
        kColors.thirdInRankingColor,
        0xE5E5FF
    ]
    
    init(user: User, ranking: Int) {
        self.user = user
        self.ranking = ranking
    }
    
    convenience init(user: User) {
        self.init(user: user, ranking: 0)
    }
    
    func isPodiumRanking() -> Bool {
        return ranking < 4 && ranking > 0
    }

    func rankingImageName() -> String? {
        if isPodiumRanking() {
            return medalImages[ranking - 1]
        }
        return nil
    }
    
    func backgroundColor() -> UInt? {
        if isPodiumRanking() {
            return positionColors[ranking - 1]
        }
        return nil
    }
    
    func avatarBackgroundColor() -> UInt? {
        if isPodiumRanking() {
            return avatarBGColors[ranking - 1]
        }
        return nil
    }
    
    func login() -> String {
        return user.login!
    }
    
    func avatarUrl() -> String? {
        return user.avatarUrl
    }
    
    func stars() -> String {
        return "\(user.starsCount ?? 0)"
    }
    
    func hasLocation() -> Bool {
        return user.hasLocation()
    }
    
    var fullLocation: String {
        let city = user.city?.capitalizedString
        let country = user.country?.capitalizedString
        return String.join(", ", country, city)
    }
    
    var gitHubUrl: String {
        return "https://www.github.com/\(user.login!)"
    }
}
