//
//  RankingPresenterTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
import XCTest

@testable import OctoPodium

class RankingPresenterTests: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var rankingPresenter: RankingPresenter!
        var zeroPresenter: RankingPresenter!
        var onePresenter: RankingPresenter!
        var twoPresenter: RankingPresenter!
        
        describe("Ranking presenter") {
            
            context("Podium independent information (stars, repos and language") {
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 0, total: 12432234),
                        country: CountryRanking(name: "Portugal", position: 0, total: 1234),
                        city: CityRanking(name: "Lisbon", position: 0, total: 102),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )
                    rankingPresenter = RankingPresenter(ranking: ranking)
               }
                
                it("contains language") {
                    expect(rankingPresenter.language).to(equal("Swift"))
                }
                
                it("contains city") {
                    expect(rankingPresenter.city).to(equal("Lisbon"))
                }
                
                it("contains country") {
                    expect(rankingPresenter.country).to(equal("Portugal"))
                }
                
                it("contains stars") {
                    expect(rankingPresenter.stars).to(equal(823))
                }
                
                it("Contains repositories") {
                    expect(rankingPresenter.repositories).to(equal(4))
                }

            }
            
            context("No ranking") {
                
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 0, total: 12432234),
                        country: CountryRanking(name: "Portugal", position: 0, total: 1234),
                        city: CityRanking(name: "Lisbon", position: 0, total: 102),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns -/- ranking for city") {
                    expect(rankingPresenter.cityRanking).to(equal(0))
                }

                it("returns -/- ranking for country") {
                    expect(rankingPresenter.countryRanking).to(equal(0))
                }
                
                it("returns -/- ranking for world") {
                    expect(rankingPresenter.worldRanking).to(equal(0))
                }
            }
            
            context("1st in ranking") {
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 1, total: 32332),
                        country: CountryRanking(name: "Portugal", position: 1, total: 5),
                        city: CityRanking(name: "Lisbon", position: 1, total: 342),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns ranking for city") {
                    expect(rankingPresenter.cityRankingOverView).to(equal("1/342"))
                }

                it("returns ranking for country") {
                    expect(rankingPresenter.countryRankingOverView).to(equal("1/5"))
                }

                it("returns ranking for world") {
                    expect(rankingPresenter.worldRankingOverView).to(equal("1/32332"))
                }
            }
            
            context("2nd in ranking") {
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 2, total: 523),
                        country: CountryRanking(name: "Portugal", position: 2, total: 5),
                        city: CityRanking(name: "Lisbon", position: 2, total: 432),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )

                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns ranking for city") {
                    expect(rankingPresenter.cityRankingOverView).to(equal("2/432"))
                }

                it("returns ranking for country") {
                    expect(rankingPresenter.countryRankingOverView).to(equal("2/5"))
                }

                it("returns ranking for world") {
                    expect(rankingPresenter.worldRankingOverView).to(equal("2/523"))
                }
            }
            
            context("3rd in ranking") {
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 3, total: 343433),
                        country: CountryRanking(name: "Portugal", position: 3, total: 456),
                        city: CityRanking(name: "Lisbon", position: 3, total: 102),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )

                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns ranking for city") {
                    expect(rankingPresenter.cityRanking).to(equal(3))
                }
                
                it("returns ranking for country") {
                    expect(rankingPresenter.countryRanking).to(equal(3))
                }
                
                it("returns ranking for world") {
                    expect(rankingPresenter.worldRanking).to(equal(3))
                }
            }
            
            context("4th in ranking") {
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 4, total: 12432234),
                        country: CountryRanking(name: "Portugal", position: 4, total: 543),
                        city: CityRanking(name: "Lisbon", position: 4, total: 765),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns ranking for city") {
                    expect(rankingPresenter.cityRanking).to(equal(4))
                }
                
                it("returns ranking for country") {
                    expect(rankingPresenter.countryRanking).to(equal(4))
                }
                
                it("returns ranking for world") {
                    expect(rankingPresenter.worldRanking).to(equal(4))
                }
            }
            
            context("1000th in ranking") {
                beforeEach {
                    let ranking = Ranking(
                        world: WorldRanking(position: 1000, total: 23094324),
                        country: CountryRanking(name: "Portugal", position: 1000, total: 1000),
                        city: CityRanking(name: "Lisbon", position: 1000, total: 12343),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )
                    
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns ranking for city") {
                    expect(rankingPresenter.cityRanking).to(equal(1000))
                }
                
                it("returns ranking for country") {
                    expect(rankingPresenter.countryRanking).to(equal(1000))
                }
                
                it("returns ranking for world") {
                    expect(rankingPresenter.worldRanking).to(equal(1000))
                }
            }
            
            context("has medals") {
                beforeEach {

                    let zeroMedalsRanking = Ranking(
                        world: WorldRanking(position: 4, total: 12432234),
                        country: CountryRanking(name: "Portugal", position: 4, total: 543),
                        city: CityRanking(name: "Lisbon", position: 4, total: 765),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )

                    let oneMedalRanking = Ranking(
                        world: WorldRanking(position: 4, total: 12432234),
                        country: CountryRanking(name: "Portugal", position: 4, total: 543),
                        city: CityRanking(name: "Lisbon", position: 1, total: 765),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )

                    let twoMedalsRanking = Ranking(
                        world: WorldRanking(position: 4, total: 12432234),
                        country: CountryRanking(name: "Portugal", position: 2, total: 543),
                        city: CityRanking(name: "Lisbon", position: 1, total: 765),
                        language: "Swift",
                        repositories: 4,
                        stars: 823
                    )
                    
                    zeroPresenter = RankingPresenter(ranking: zeroMedalsRanking)
                    onePresenter = RankingPresenter(ranking: oneMedalRanking)
                    twoPresenter = RankingPresenter(ranking: twoMedalsRanking)
                }
                
                it("has no medals") {
                    expect(zeroPresenter.hasMedals).to(equal(false))
                    expect(onePresenter.hasMedals).to(equal(true))
                    expect(twoPresenter.hasMedals).to(equal(true))
                }
                
            }
        }
    }    
}
