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

    let cityRanking: CityRanking?
    let cityRankingOverView: String

    let countryRanking: CountryRanking?
    let countryRankingOverView: String

    let worldRanking: WorldRanking
    let worldRankingOverView: String

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

        cityRanking = ranking.city
        cityRankingOverView = ranking.city?.description ?? ""

        countryRanking = ranking.country
        countryRankingOverView = ranking.country?.description ?? ""

        worldRanking = ranking.world
        worldRankingOverView = ranking.world.description

        repositories = ranking.repositories ?? 0
        stars = ranking.stars

        let rankings: [Int?] = [ranking.world.position, ranking.country?.position, ranking.city?.position]

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
