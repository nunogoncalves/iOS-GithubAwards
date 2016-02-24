//
//  RankingTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 24/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
import XCTest

@testable import OctoPodium

class RankingTests : QuickSpec {
 
    
    override func spec() {
        describe("Ranking model") {
            
            context("Trophies") {
                
                it("returns proper trophies count") {
                    let alteranatives = [
                        [0, 0, 0],
                        [0, 0, 1],
                        [0, 1, 0],
                        [0, 1, 1],
                        [1, 0, 0],
                        [1, 0, 1],
                        [1, 1, 0],
                        [1, 1, 1],
                    ]
                    for alternative in alteranatives {
                        let expectedTotal = alternative[0] + alternative[1] + alternative[2]
                        
                        let ranking = self.buildRankingWith(alternative[0], countryRanking: alternative[1], worldRanking: alternative[2])
                        
                        expect(ranking.trophies).to(equal(expectedTotal))
                    }
                }
                
                it("returns proper trophies count when rankings are nil") {
                    let ranking = self.buildRankingWith(nil, countryRanking: nil, worldRanking: nil)
                    
                    expect(ranking.trophies).to(equal(0))
                }
            }
        }
    }
    
    private func buildRankingWith(cityRanking: Int?, countryRanking: Int?, worldRanking: Int?) -> Ranking {
        let ranking = Ranking(city: "",
            cityRanking: cityRanking,
            cityTotal: 123,
            country: "",
            countryTotal: 1000,
            countryRanking: countryRanking,
            worldRanking: worldRanking,
            worldTotal: 1000,
            language: "",
            repositories: 123, stars: 1234)
        return ranking
    }
}