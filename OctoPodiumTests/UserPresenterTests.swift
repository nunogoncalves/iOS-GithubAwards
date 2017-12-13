//
//  UserPresenterTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
import XCTest

@testable import OctoPodium

class UserPresenterTests: QuickSpec {
    
    override func spec() {
        
        var user: User!
        var userPresenter: UserPresenter!

        describe("UserPresenter") {
            
            context("Stars Repos and Trophies") {
                beforeEach {
                    user = User(login: "Walter White", avatarUrl: "WalterWhiteAvatarUrl")
                    let ranking1 = TestsBuilder.buildRankingWith(cityRanking: 1, countryRanking: 1, worldRanking: 0)
                    let ranking2 = TestsBuilder.buildRankingWith(cityRanking: 2, countryRanking: 0, worldRanking: 2)
                    
                    user.rankings = [ranking1, ranking2]
                    userPresenter = UserPresenter(user: user, ranking: 1000)
                }
                
                it("has repos stars and trophies podium") {
                    expect(userPresenter.totalRepositories).to(equal(246))
                    expect(userPresenter.totalTrophies).to(equal(4))
                    expect(userPresenter.totalStars).to(equal(2468))
                }
            }
            
            context("User is first in ranking") {
                beforeEach {
                    user = User(login: "nuno", avatarUrl: "AvatarUrl")
                    userPresenter = UserPresenter(user: user, ranking: 1)
                }
                
                it("is in podium") {
                    XCTAssertEqual(userPresenter.isPodiumRanking(), true)
                }
                
                it("has 1st place background color") {
                    XCTAssertEqual(
                        userPresenter.backgroundColor(),
                        kColors.firstInRankingColor,
                        "Expected 1st place color to be \(kColors.firstInRankingColor)"
                    )
                }
                
                it("has 1st place avatar background color") {
                    XCTAssertEqual(
                        userPresenter.avatarBackgroundColor(),
                        kColors.secondInRankingColor,
                        "Expected 1st place color to be \(kColors.secondInRankingColor)"
                    )
                }

                it("returns gold trophy image name") {
                    XCTAssertEqual(userPresenter.rankingImageName(), "GoldMedal", "Expected image name to be GoldMedal")
                }
                
                it("returns login") {
                    XCTAssertEqual(userPresenter.login, "nuno", "Expected login to be Nuno")
                }
                
                it("returns avatar url") {
                    XCTAssertEqual(userPresenter.avatarUrl, "AvatarUrl", "Expected avatar to be AvatarUrl")
                }
            }
            
            context("User is second in ranking") {
                beforeEach {
                    user = User(login: "Katrina", avatarUrl: "KatrinaAvatarUrl")
                    userPresenter = UserPresenter(user: user, ranking: 2)
                }
                
                it("is in podium") {
                    XCTAssertEqual(userPresenter.isPodiumRanking(), true)
                }
                
                it("has 1st place background color") {
                    XCTAssertEqual(
                        userPresenter.backgroundColor(),
                        kColors.secondInRankingColor,
                        "Expected 1st place color to be \(kColors.secondInRankingColor)"
                    )
                }
                
                it("has 2nd place avatar background color") {
                    XCTAssertEqual(
                        userPresenter.avatarBackgroundColor(),
                        kColors.thirdInRankingColor,
                        "Expected 2nd place color to be \(kColors.thirdInRankingColor)"
                    )
                }
                
                it("returns silver trophy image name") {
                    XCTAssertEqual(userPresenter.rankingImageName(), "SilverMedal", "Expected image name to be SilverMedal")
                }
                
                it("returns login") {
                    XCTAssertEqual(userPresenter.login, "Katrina", "Expected login to be Katrina")
                }
                
                it("returns avatar url") {
                    XCTAssertEqual(userPresenter.avatarUrl, "KatrinaAvatarUrl", "Expected avatar to be KatrinaAvatarUrl")
                }
            }
            
            context("User is third in ranking") {
                beforeEach {
                    user = User(login: "Bianca", avatarUrl: "BiancaAvatarUrl")
                    userPresenter = UserPresenter(user: user, ranking: 3)
                }
                
                it("is in podium") {
                    XCTAssertEqual(userPresenter.isPodiumRanking(), true)
                }
                
                it("has 3rd place background color") {
                    XCTAssertEqual(
                        userPresenter.backgroundColor(),
                        kColors.thirdInRankingColor,
                        "Expected 3rd place color to be \(kColors.thirdInRankingColor)"
                    )
                }
                
                it("has 3rd place avatar background color") {
                    XCTAssertEqual(
                        userPresenter.avatarBackgroundColor(),
                        0xE5E5FF,
                        "Expected 3rd place color to be \(0xE5E5FF)"
                    )
                }
                
                it("returns bronze trophy image name") {
                    XCTAssertEqual(
                        userPresenter.rankingImageName(),
                        "BronzeMedal",
                        "Expected image name to be BronzeMedal"
                    )
                }
                
                it("returns login") {
                    XCTAssertEqual(
                        userPresenter.login,
                        "Bianca",
                        "Expected login to be Bianca"
                    )
                }
                
                it("returns avatar url") {
                    XCTAssertEqual(
                        userPresenter.avatarUrl,
                        "BiancaAvatarUrl",
                        "Expected avatar to be BiancaAvatarUrl"
                    )
                }
            }
            
            context("User is fourth in ranking") {
                beforeEach {
                    user = User(login: "HarrisonFord", avatarUrl: "HarrisonAvatarUrl")
                    userPresenter = UserPresenter(user: user, ranking: 4)
                }
                
                it("is not in podium") {
                    XCTAssertEqual(userPresenter.isPodiumRanking(), false)
                }
                
                it("has 4th place background color") {
                    XCTAssertEqual(
                        userPresenter.backgroundColor(),
                        nil,
                        "Expected 4th place color to be nil"
                    )
                }
                
                it("has 4th place avatar background color") {
                    XCTAssertEqual(
                        userPresenter.avatarBackgroundColor(),
                        nil,
                        "Expected 4th place color to be nil"
                    )
                }
                
                it("returns regular trophy image name") {
                    XCTAssertEqual(
                        userPresenter.rankingImageName(),
                        nil,
                        "Expected image name to be nil")
                }
                
                it("returns login") {
                    XCTAssertEqual(userPresenter.login, "HarrisonFord", "Expected login to be HarrisonFord")
                }
                
                it("returns avatar url") {
                    XCTAssertEqual(userPresenter.avatarUrl, "HarrisonAvatarUrl", "Expected avatar to be HarrisonAvatarUrl")
                }
            }
            
            context("User is 1000th in ranking") {
                beforeEach {
                    user = User(login: "Walter White", avatarUrl: "WalterWhiteAvatarUrl")
                    userPresenter = UserPresenter(user: user, ranking: 1000)
                }
                
                it("is not in podium") {
                    XCTAssertEqual(userPresenter.isPodiumRanking(), false)
                }
                
                it("has regular place background color") {
                    XCTAssertEqual(
                        userPresenter.backgroundColor(),
                        nil,
                        "Expected 4th place color to be nil"
                    )
                }
                
                it("has regular place avatar background color") {
                    XCTAssertEqual(
                        userPresenter.avatarBackgroundColor(),
                        nil,
                        "Expected 4th place color to be nil"
                    )
                }
                
                it("returns regular trophy image name") {
                    XCTAssertEqual(
                        userPresenter.rankingImageName(),
                        nil,
                        "Expected image name to be nil")
                }
                
                it("returns login") {
                    XCTAssertEqual(userPresenter.login, "Walter White", "Expected login to be HarrisonFord")
                }
                
                it("returns avatar url") {
                    XCTAssertEqual(userPresenter.avatarUrl, "WalterWhiteAvatarUrl", "Expected avatar to be HarrisonAvatarUrl")
                }
            }

        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    
    func testPerformanceExample() {
//        self.measureBlock {}
    }

}
