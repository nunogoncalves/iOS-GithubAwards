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
                    let ranking = Ranking(city: "Lisbon", cityRanking: 0, cityTotal: 102, country: "Portugal", countryTotal: 1234, countryRanking: 0, worldRanking: 0, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
                    
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
                    let ranking = Ranking(city: "Lisbon", cityRanking: 0, cityTotal: 102, country: "Portugal", countryTotal: 1234, countryRanking: 0, worldRanking: 0, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
                    
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
                    let ranking = Ranking(city: "Lisbon", cityRanking: 1, cityTotal: 342, country: "Portugal", countryTotal: 5, countryRanking: 1, worldRanking: 1, worldTotal: 32332, language: "Swift", repositories: 4, stars: 823)
                    
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
//                it("returns ranking for city") {
//                    expect(rankingPresenter.rankingForCity).to(equal("1/342"))
//                }
//                
//                it("returns ranking for country") {
//                    expect(rankingPresenter.rankingForCountry).to(equal("1/5"))
//                }
//                
//                it("returns ranking for world") {
//                    expect(rankingPresenter.rankingForWorld).to(equal("1/32332"))
//                }
            }
            
            context("2nd in ranking") {
                beforeEach {
                    let ranking = Ranking(city: "Lisbon", cityRanking: 2, cityTotal: 432, country: "Portugal", countryTotal: 5, countryRanking: 2, worldRanking: 2, worldTotal: 523, language: "Swift", repositories: 4, stars: 823)
                    
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
//                it("returns ranking for city") {
//                    expect(rankingPresenter.rankingForCity).to(equal("2/432"))
//                }
//                
//                it("returns ranking for country") {
//                    expect(rankingPresenter.rankingForCountry).to(equal("2/5"))
//                }
//                
//                it("returns ranking for world") {
//                    expect(rankingPresenter.rankingForWorld).to(equal("2/523"))
//                }                
            }
            
            context("3rd in ranking") {
                beforeEach {
                    let ranking = Ranking(city: "Lisbon", cityRanking: 3, cityTotal: 102, country: "Portugal", countryTotal: 456, countryRanking: 3, worldRanking: 3, worldTotal: 343433, language: "Swift", repositories: 4, stars: 823)
                    
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
                    let ranking = Ranking(city: "Lisbon", cityRanking: 4, cityTotal: 765, country: "Portugal", countryTotal: 543, countryRanking: 4, worldRanking: 4, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
                    
                    rankingPresenter = RankingPresenter(ranking: ranking)
                }
                
                it("returns ranking for city") {
                    expect(rankingPresenter.cityRanking).to(equal(4))
                }
                
                it("returns ranking for country") {
                    expect(rankingPresenter.countryRanking).to(equal(4))
                }
                
                it("returns ranking for world") {
                    expect(rankingPresenter.worldRanking).to(equal( 4))
                }
            }
            
            context("1000th in ranking") {
                beforeEach {
                    let ranking = Ranking(city: "Lisbon", cityRanking: 1000, cityTotal: 12343, country: "Portugal", countryTotal: 5999, countryRanking: 1000, worldRanking: 1000, worldTotal: 23094324, language: "Swift", repositories: 4, stars: 823)
                    
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
                    let zeroMedalsRanking = Ranking(city: "Lisbon", cityRanking: 4, cityTotal: 765, country: "Portugal", countryTotal: 543, countryRanking: 4, worldRanking: 4, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
                    let oneMedalRanking = Ranking(city: "Lisbon", cityRanking: 1, cityTotal: 765, country: "Portugal", countryTotal: 543, countryRanking: 4, worldRanking: 4, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
                    
                    let twoMedalsRanking = Ranking(city: "Lisbon", cityRanking: 1, cityTotal: 765, country: "Portugal", countryTotal: 543, countryRanking: 2, worldRanking: 4, worldTotal: 12432234, language: "Swift", repositories: 4, stars: 823)
                    
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
