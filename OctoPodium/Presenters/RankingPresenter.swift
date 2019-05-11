//
//  RankingPresenter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

private typealias SELF = RankingPresenter

struct RankingPresenter {
    
    private let ranking: Ranking
    
    var userLogin: String { return ranking.user?.login ?? "" }
    let language: String

    let city: String
    let cityRanking: Int
    let cityTotal: Int
    let cityRankingOverView: String

    let country: String
    let countryRanking: Int
    let countryTotal: Int
    let rankingOverViewForCountry: String

    let worldRanking: Int
    let worldTotal: Int
    let rankingOverViewForWorld: String

    let repositories: Int
    let stars: Int

    let hasMedals: Bool
    let hasGoldMedal: Bool
    let hasSilverMedal: Bool
    let hasBronzeMedal: Bool
    let numberOfDifferentMedals: Int

    let headerColorHex: UInt
    let textColor: UInt

    let repoImage: UIImage
    let starImage: UIImage

    let medals: Medals

    init(ranking: Ranking) {
        self.ranking = ranking

        language = ranking.language ?? ""

        city = ranking.city?.capitalized ?? ""
        cityRanking = ranking.cityRanking ?? 0
        cityTotal = ranking.cityTotal ?? 0
        cityRankingOverView = SELF.rankingOverview(for: cityRanking, locationTotal: cityTotal)

        country = ranking.country?.capitalized ?? ""
        countryRanking = ranking.countryRanking ?? 0
        countryTotal = ranking.countryTotal ?? 0
        rankingOverViewForCountry = SELF.rankingOverview(for: countryRanking, locationTotal: countryTotal)

        worldRanking = ranking.worldRanking ?? 0
        worldTotal = ranking.worldTotal ?? 0
        rankingOverViewForWorld = SELF.rankingOverview(for: worldRanking, locationTotal: worldTotal)

        repositories = ranking.repositories ?? 0
        stars = ranking.stars

        let rankings = [worldRanking, countryRanking, cityRanking]

        hasGoldMedal = rankings.any { $0 == 1 }
        hasSilverMedal = rankings.any { $0 == 2 }
        hasBronzeMedal = rankings.any { $0 == 3 }
        numberOfDifferentMedals = [hasGoldMedal, hasSilverMedal, hasBronzeMedal].count { $0 }
        hasMedals = numberOfDifferentMedals > 0

        var _medals: Medals = []
        if hasGoldMedal { _medals.insert(.gold) }
        if hasSilverMedal { _medals.insert(.silver) }
        if hasBronzeMedal { _medals.insert(.bronze) }
        medals = _medals

        headerColorHex = hasMedals ? 0x03436E : 0xE0E0E0
        textColor = hasMedals ? 0xFFFFFF : 0x313131
        repoImage = hasMedals ? #imageLiteral(resourceName: "Repository") : #imageLiteral(resourceName: "RepositoryDark")
        starImage = hasMedals ? #imageLiteral(resourceName: "Star") : #imageLiteral(resourceName: "StarDark")
    }

    private static func rankingOverview(for rank: Int, locationTotal: Int) -> String {
        guard rank > 0 && locationTotal > 0 else { return "-/-" }
        return "\(rank)/\(locationTotal)"
    }
}

private extension Array {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try reduce(0) { $0 + (try predicate($1) ? 1 : 0) }
    }

    func any(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try first(where: predicate) != nil
    }
}
