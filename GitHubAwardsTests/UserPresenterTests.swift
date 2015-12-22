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

    var nunoWithAvatar: User!
    var userPresenter_1st: UserPresenter!
    var userPresenter_2nd: UserPresenter!
    var userPresenter_3rd: UserPresenter!
    var userPresenter_4th: UserPresenter!
    
    override func setUp() {
        super.setUp()
        nunoWithAvatar = User(login: "nuno", avatarUrl: "AvatarUrl")
        userPresenter_1st = UserPresenter(user: nunoWithAvatar, ranking: 1)
        userPresenter_2nd = UserPresenter(user: nunoWithAvatar, ranking: 2)
        userPresenter_3rd = UserPresenter(user: nunoWithAvatar, ranking: 3)
        userPresenter_4th = UserPresenter(user: nunoWithAvatar, ranking: 4)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIsInPodium() {
        for i in 1...3 {
            let userPresenter = UserPresenter(user: nunoWithAvatar, ranking: i)
            XCTAssertEqual(userPresenter.isPodiumRanking(), true, "Expected user ranking (\(i)) to be in the podium")
        }
    }

    func testIsNotInPodium() {
        XCTAssertEqual(userPresenter_4th.isPodiumRanking(), false, "Expected user not to be in the podium")
    }

    
    func testRankingColors() {
        XCTAssertEqual(userPresenter_1st.backgroundColor(), K.firstInRankingColor, "Expected 1st place color to be \(K.firstInRankingColor)")

        XCTAssertEqual(userPresenter_2nd.backgroundColor(), K.secondInRankingColor, "Expected 1st place color to be \(K.secondInRankingColor)")

        XCTAssertEqual(userPresenter_3rd.backgroundColor(), K.thirdInRankingColor, "Expected 1st place color to be \(K.thirdInRankingColor)")
        
       
        XCTAssertEqual(userPresenter_4th.backgroundColor(), nil, "Expected 1st place color to be \(K.firstInRankingColor)")
    }
    
    func testAvatarBgColors() {
        XCTAssertEqual(userPresenter_1st.avatarBackgroundColor(), K.secondInRankingColor, "Expected 1st place color to be \(K.secondInRankingColor)")
        
        XCTAssertEqual(userPresenter_2nd.avatarBackgroundColor(), K.thirdInRankingColor, "Expected 2nd place color to be \(K.thirdInRankingColor)")
        
        XCTAssertEqual(userPresenter_3rd.avatarBackgroundColor(), 0xE5E5FF, "Expected 3rd place color to be \(0xE5E5FF)")
        
        XCTAssertEqual(userPresenter_4th.avatarBackgroundColor(), nil, "Expected 4th place color to be \(K.firstInRankingColor)")
    }
    
    func testRankingImageName() {
        XCTAssertEqual(userPresenter_4th.rankingImageName(), "4.png", "Expected image name to be 4.png")
    }
    
    func testLogin() {
        XCTAssertEqual(userPresenter_4th.login(), "nuno", "Expected login to be Nuno")
    }
    
    func testAvatar() {
        XCTAssertEqual(userPresenter_4th.avatarUrl(), "AvatarUrl", "Expected avatar to be AvatarUrl")
    }
    
    func testPerformanceExample() {
//        self.measureBlock {
//        }
    }

}
