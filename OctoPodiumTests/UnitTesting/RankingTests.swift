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
                        
                        let ranking = TestsBuilder.buildRankingWith(
                            cityRanking: alternative[0],
                            countryRanking: alternative[1],
                            worldRanking: alternative[2]
                        )
                        
                        expect(ranking.trophies).to(equal(expectedTotal))
                    }
                }
                
                it("returns proper trophies count when rankings are nil (except world)") {
                    let ranking = TestsBuilder.buildRankingWith(
                        cityRanking: nil,
                        countryRanking: nil,
                        worldRanking: 0
                    )
                    
                    expect(ranking.trophies).to(equal(0))
                }
            }
        }
    }
    
    
}
