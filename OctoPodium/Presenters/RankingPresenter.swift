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

    @available(*, deprecated, message: "to be removed")
    var city: String { return ranking.city?.name ?? "" }
    @available(*, deprecated, message: "to be removed")
    var cityRanking: Int { return ranking.city?.rank ?? 0 }
    @available(*, deprecated, message: "to be removed")
    var cityTotal: Int { return ranking.city?.total ?? 0 }

    let cityRankingOverView: String

    @available(*, deprecated, message: "to be removed")
    var country: String  { return ranking.country?.name ?? "" }
    @available(*, deprecated, message: "to be removed")
    var countryRanking: Int { return ranking.country?.rank ?? 0 }
    @available(*, deprecated, message: "to be removed")
    var countryTotal: Int { return ranking.country?.total ?? 0 }
    let countryRankingOverView: String

    @available(*, deprecated, message: "to be removed")
    var worldRanking: Int { return ranking.world.rank }
    @available(*, deprecated, message: "to be removed")
    var worldTotal: Int { return ranking.world.total }
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

        cityRankingOverView = ranking.city?.description ?? ""
        countryRankingOverView = ranking.country?.description ?? ""
        worldRankingOverView = ranking.world.description

        repositories = ranking.repositories ?? 0
        stars = ranking.stars

        let rankings: [Int?] = [ranking.world.position, ranking.country?.rank, ranking.city?.rank]

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
