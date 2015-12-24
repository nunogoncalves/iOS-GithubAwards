//
//  RankingPresenter.swift
//  GitHubAwards
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

    var city: String { get { return ranking.city ?? "" } }
    private var cityRanking: Int { get { return ranking.cityRanking ?? 0 } }
    private var cityTotal: Int { get { return ranking.cityTotal ?? 0 } }
    var rankingForCity: String {
        get {
            return rankingOverviewFor(cityRanking, locationTotal: cityTotal)
        }
    }

    var country: String { get { return ranking.country ?? "" } }
    private var countryRanking: Int { get { return ranking.countryRanking ?? 0 } }
    private var countryTotal: Int { get { return ranking.countryTotal ?? 0 } }
    var rankingForCountry: String {
        get {
            return rankingOverviewFor(countryRanking, locationTotal: countryTotal)
        }
    }
    
    private var worldRanking: Int { get { return ranking.worldRanking ?? 0 } }
    private var worldTotal: Int { get { return ranking.worldTotal ?? 0 } }
    var rankingForWorld: String {
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
    
    private func rankingOverviewFor(rank: Int, locationTotal: Int) -> String {
        if rank > 0 && locationTotal > 0 {
            return "\(rank)/\(locationTotal)"
        } else {
            return "-/-"
        }
    }
    
    var cityRankingImage: String { get { return getThrofyFor(cityRanking) } }
    var countryRankingImage: String { get { return getThrofyFor(countryRanking) } }
    var worldRankingImage: String { get { return getThrofyFor(worldRanking) } }
    
    private func getThrofyFor(ranking: Int) -> String {
        var rank = ranking
        if (rank < 1 || rank > 3) { rank = 4 }
        return throphies[rank]!
    }
    
    var repositories: String { get { return "\(repos)" } }
    private var repos: Int { get { return ranking.repositories ?? 0 } }
    var stars: String { get { return "\(starsInt)" } }
    private var starsInt: Int { get { return ranking.stars ?? 0 } }
}