//
//  RankingPresenterTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 24/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import GitHubAwards

class RankingPresenterTests: XCTestCase {
    
    var noRankingLisbonSwift = Ranking(city: "Lisbon", cityRanking: 0, cityTotal: 102, country: "Portugal", countryTotal: 1234, countryRanking: 0, worldRanking: 0, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
    
    var firstRankingLisbonSwift = Ranking(city: "Lisbon", cityRanking: 1, cityTotal: 342, country: "Portugal", countryTotal: 5, countryRanking: 1, worldRanking: 1, worldTotal: 32332, language: "Swift", repositories: 4, stars: 823)

    var secondRankingLisbonSwift = Ranking(city: "Lisbon", cityRanking: 2, cityTotal: 432, country: "Portugal", countryTotal: 5, countryRanking: 2, worldRanking: 2, worldTotal: 523, language: "Swift", repositories: 4, stars: 823)

    var thirdRankingLisbonSwift = Ranking(city: "Lisbon", cityRanking: 3, cityTotal: 102, country: "Portugal", countryTotal: 456, countryRanking: 3, worldRanking: 3, worldTotal: 343433, language: "Swift", repositories: 4, stars: 823)

    var fourthRankingLisbonSwift = Ranking(city: "Lisbon", cityRanking: 4, cityTotal: 765, country: "Portugal", countryTotal: 543, countryRanking: 4, worldRanking: 4, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)

    var thousandthRankingLisbonSwift = Ranking(city: "Lisbon", cityRanking: 1000, cityTotal: 12343, country: "Portugal", countryTotal: 5999, countryRanking: 1000, worldRanking: 1000, worldTotal: 23094324, language: "Swift", repositories: 4, stars: 823)

    var rankingPresenter: RankingPresenter!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLanguage() {
        rankingPresenter = RankingPresenter(ranking: firstRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.language, "Swift")
    }
    
    func testStars() {
        rankingPresenter = RankingPresenter(ranking: firstRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.stars, "823")
    }

    func testRepos() {
        rankingPresenter = RankingPresenter(ranking: firstRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.repositories, "4")
    }
    
    func testNoRanking() {
        rankingPresenter = RankingPresenter(ranking: noRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.rankingForCity, "-/-")
        XCTAssertEqual(rankingPresenter.rankingForCountry, "-/-")
        XCTAssertEqual(rankingPresenter.rankingForWorld, "-/-")
        
        XCTAssertEqual(rankingPresenter.cityRankingImage, "Trophy")
        XCTAssertEqual(rankingPresenter.countryRankingImage, "Trophy")
        XCTAssertEqual(rankingPresenter.worldRankingImage, "Trophy")
    }
    
    func test1stRanking() {
        rankingPresenter = RankingPresenter(ranking: firstRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.rankingForCity, "1/342")
        XCTAssertEqual(rankingPresenter.rankingForCountry, "1/5")
        XCTAssertEqual(rankingPresenter.rankingForWorld, "1/32332")
        
        XCTAssertEqual(rankingPresenter.cityRankingImage, "GoldTrophy")
        XCTAssertEqual(rankingPresenter.countryRankingImage, "GoldTrophy")
        XCTAssertEqual(rankingPresenter.worldRankingImage, "GoldTrophy")
    }
    
    func test2ndRanking() {
        rankingPresenter = RankingPresenter(ranking: secondRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.rankingForCity, "2/432")
        XCTAssertEqual(rankingPresenter.rankingForCountry, "2/5")
        XCTAssertEqual(rankingPresenter.rankingForWorld, "2/523")
        
        XCTAssertEqual(rankingPresenter.cityRankingImage, "SilverTrophy")
        XCTAssertEqual(rankingPresenter.countryRankingImage, "SilverTrophy")
        XCTAssertEqual(rankingPresenter.worldRankingImage, "SilverTrophy")
    }
    
    func test3rdRanking() {
        rankingPresenter = RankingPresenter(ranking: thirdRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.rankingForCity, "3/102")
        XCTAssertEqual(rankingPresenter.rankingForCountry, "3/456")
        XCTAssertEqual(rankingPresenter.rankingForWorld, "3/343433")
        
        XCTAssertEqual(rankingPresenter.cityRankingImage, "BronzeTrophy")
        XCTAssertEqual(rankingPresenter.countryRankingImage, "BronzeTrophy")
        XCTAssertEqual(rankingPresenter.worldRankingImage, "BronzeTrophy")
    }
    
    func test4thRanking() {
        rankingPresenter = RankingPresenter(ranking: fourthRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.rankingForCity, "4/765")
        XCTAssertEqual(rankingPresenter.rankingForCountry, "4/543")
        XCTAssertEqual(rankingPresenter.rankingForWorld, "4/12432234")
        
        XCTAssertEqual(rankingPresenter.cityRankingImage, "Trophy")
        XCTAssertEqual(rankingPresenter.countryRankingImage, "Trophy")
        XCTAssertEqual(rankingPresenter.worldRankingImage, "Trophy")
    }
    
    func test1000thRanking() {
        rankingPresenter = RankingPresenter(ranking: thousandthRankingLisbonSwift)
        XCTAssertEqual(rankingPresenter.rankingForCity, "1000/12343")
        XCTAssertEqual(rankingPresenter.rankingForCountry, "1000/5999")
        XCTAssertEqual(rankingPresenter.rankingForWorld, "1000/23094324")
        
        XCTAssertEqual(rankingPresenter.cityRankingImage, "Trophy")
        XCTAssertEqual(rankingPresenter.countryRankingImage, "Trophy")
        XCTAssertEqual(rankingPresenter.worldRankingImage, "Trophy")
    }
    
    func testPerformanceExample() {
//        self.measureBlock {}
    }
    
}
