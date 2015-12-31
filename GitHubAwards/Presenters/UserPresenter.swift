//
//  TopUserPresenter.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 18/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

protocol TopUserView {
    
}

class UserPresenter {
    
    let user: User
    let ranking: Int
    
    private let positionColors: [UInt] = [
        K.firstInRankingColor,
        K.secondInRankingColor,
        K.thirdInRankingColor
    ]
    private let avatarBGColors: [UInt] = [
        K.secondInRankingColor,
        K.thirdInRankingColor,
        0xE5E5FF
    ]
    
    init(user: User, ranking: Int) {
        self.user = user
        self.ranking = ranking
    }
    
    func isPodiumRanking() -> Bool {
        return ranking < 4 && ranking > 0
    }
    
    func rankingImageName() -> String? {
        if isPodiumRanking() {
            return "\(ranking).png"
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
}
