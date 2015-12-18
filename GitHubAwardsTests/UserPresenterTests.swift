//
//  UserPresenterTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 18/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import GitHubAwards

class UserPresenterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIsInPodium() {
        for i in 1...3 {
            let user = User(login: "nuno", avatarUrl: "AvatarUrl")
            let userPresenter = UserPresenter(user: user, ranking: i)
            
            XCTAssertEqual(userPresenter.isPodiumRanking(), true, "Expected user ranking (\(i)) to be in the podium")
        }
    }

    func testIsNotInPodium() {
        let user = User(login: "nuno", avatarUrl: "AvatarUrl")
        let userPresenter = UserPresenter(user: user, ranking: 4)
        
        XCTAssertEqual(userPresenter.isPodiumRanking(), false, "Expected user not to be in the podium")
    }

    
    func testRankingColors() {
        var user = User(login: "nuno", avatarUrl: "AvatarUrl")
        var userPresenter = UserPresenter(user: user, ranking: 1)
        XCTAssertEqual(userPresenter.backgroundColor(), K.firstInRankingColor, "Expected 1st place color to be \(K.firstInRankingColor)")

        user = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter = UserPresenter(user: user, ranking: 2)
       
        XCTAssertEqual(userPresenter.backgroundColor(), K.secondInRankingColor, "Expected 1st place color to be \(K.secondInRankingColor)")

        user = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter = UserPresenter(user: user, ranking: 3)
        K.thirdInRankingColor
        XCTAssertEqual(userPresenter.backgroundColor(), K.thirdInRankingColor, "Expected 1st place color to be \(K.thirdInRankingColor)")
        
        user = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter = UserPresenter(user: user, ranking: 4)
       
        XCTAssertEqual(userPresenter.backgroundColor(), nil, "Expected 1st place color to be \(K.firstInRankingColor)")
    }
    
    func testAvatarBgColors() {
        var user = User(login: "nuno", avatarUrl: "AvatarUrl")
        var userPresenter = UserPresenter(user: user, ranking: 1)
        XCTAssertEqual(userPresenter.avatarBackgroundColor(), K.secondInRankingColor, "Expected 1st place color to be \(K.secondInRankingColor)")
        
        user = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter = UserPresenter(user: user, ranking: 2)
        
        XCTAssertEqual(userPresenter.avatarBackgroundColor(), K.thirdInRankingColor, "Expected 2nd place color to be \(K.thirdInRankingColor)")
        
        user = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter = UserPresenter(user: user, ranking: 3)
        K.thirdInRankingColor
        XCTAssertEqual(userPresenter.avatarBackgroundColor(), 0xE5E5FF, "Expected 3rd place color to be \(0xE5E5FF)")
        
        user = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter = UserPresenter(user: user, ranking: 4)
        
        XCTAssertEqual(userPresenter.avatarBackgroundColor(), nil, "Expected 4th place color to be \(K.firstInRankingColor)")
    }
    
    func testRankingImageName() {
        let user = User(login: "nuno", avatarUrl: "AvatarUrl")
        let userPresenter = UserPresenter(user: user, ranking: 4)
        
        XCTAssertEqual(userPresenter.rankingImageName(), "4.png", "Expected image name to be 4.png")
    }
    
    func testLogin() {
        let user = User(login: "nuno", avatarUrl: "AvatarUrl")
        let userPresenter = UserPresenter(user: user, ranking: 4)
        
        XCTAssertEqual(userPresenter.login(), "nuno", "Expected login to be Nuno")
    }
    
    func testAvatar() {
        let user = User(login: "nuno", avatarUrl: "AvatarUrl")
        let userPresenter = UserPresenter(user: user, ranking: 4)
        XCTAssertEqual(userPresenter.avatarUrl(), "AvatarUrl", "Expected avatar to be AvatarUrl")
    }
    
    func testPerformanceExample() {
//        self.measureBlock {
//        }
    }

}
