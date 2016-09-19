//
//  RankingPresenter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class RankingPresenter {
    
    private let ranking: Ranking
    
    init(ranking: Ranking) {
        self.ranking = ranking
    }

    var userLogin: String { get { return ranking.user!.login! } }
    var language: String { get { return ranking.language ?? "" } }

    var city: String { get { return ranking.city?.capitalized ?? "" } }
    var cityRanking: Int { get { return ranking.cityRanking ?? 0 } }
    var cityTotal: Int { get { return ranking.cityTotal ?? 0 } }
    var rankingOverViewForCity: String {
        get {
            return rankingOverviewFor(cityRanking, locationTotal: cityTotal)
        }
    }

    var country: String { get { return ranking.country?.capitalized ?? "" } }
    var countryRanking: Int { get { return ranking.countryRanking ?? 0 } }
    var countryTotal: Int { get { return ranking.countryTotal ?? 0 } }
    var rankingOverViewForCountry: String {
        get {
            return rankingOverviewFor(countryRanking, locationTotal: countryTotal)
        }
    }
    
    var worldRanking: Int { get { return ranking.worldRanking ?? 0 } }
    var worldTotal: Int { get { return ranking.worldTotal ?? 0 } }
    var rankingOverViewForWorld: String {
        get {
            return rankingOverviewFor(worldRanking, locationTotal: worldTotal)
        }
    }
    
    private let throphies = [
        1: "GoldTrophy",
        2: "SilverTrophy",
        3: "BronzeTrophy",
        4: "Trophy"
    ]
    
    private func rankingOverviewFor(_ rank: Int, locationTotal: Int) -> String {
        if rank > 0 && locationTotal > 0 {
            return "\(rank)/\(locationTotal)"
        } else {
            return "-/-"
        }
    }
    
    var cityRankingImage: String { get { return getThrofyFor(cityRanking) } }
    var countryRankingImage: String { get { return getThrofyFor(countryRanking) } }
    var worldRankingImage: String { get { return getThrofyFor(worldRanking) } }
    
    private func getThrofyFor(_ ranking: Int) -> String {
        var rank = ranking
        if (rank < 1 || rank > 3) { rank = 4 }
        return throphies[rank]!
    }
    
    var repositories: String { get { return "\(repos)" } }
    private var repos: Int { get { return ranking.repositories ?? 0 } }
    var stars: String { get { return "\(starsInt)" } }
    private var starsInt: Int { get { return ranking.stars } }
    
    func hasMedals() -> Bool {
        let rankings = [worldRanking, countryRanking, cityRanking]
        return rankings.filter { $0.isPodium() }.count > 0
    }
    
    func hasGoldMedal() -> Bool {
        let rankings = [worldRanking, countryRanking, cityRanking]
        return rankings.filter { $0 == 1 }.count > 0
    }
    
    func howManyDifferentMedals() -> Int {
        var medals = 0
        if hasGoldMedal() { medals += 1 }
        if hasSilverMedal() { medals += 1 }
        if hasBronzeMedal() { medals += 1 }
        return medals
    }
    
    func hasSilverMedal() -> Bool {
        let rankings = [worldRanking, countryRanking, cityRanking]
        return rankings.filter { $0 == 2 }.count > 0
    }
    
    func hasBronzeMedal() -> Bool {
        let rankings = [worldRanking, countryRanking, cityRanking]
        return rankings.filter { $0 == 3 }.count > 0
    }
    
    func headerColorHex() -> UInt {
        return hasMedals() ? 0x03436E : 0xE0E0E0
    }
    
    func textColor() -> UInt {
        return hasMedals() ? 0xFFFFFF : 0x313131
    }
    
    func repoImage() -> String {
        return hasMedals() ? "Repository" : "RepositoryDark"
    }
    
    func starImage() -> String {
        return hasMedals() ? "Star" : "StarDark"
    }
}

private extension Int {
    func isPodium() -> Bool {
        return self < 4 && self > 0
    }
}
