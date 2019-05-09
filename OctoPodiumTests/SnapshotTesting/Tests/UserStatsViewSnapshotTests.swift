//
//  UserStatsViewSnapshotTests.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 30/03/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import Foundation

@testable import OctoPodium
import FBSnapshotTestCase

final class UserStatsViewSnapshotTests: FBSnapshotTestCase {

    private let userStats = UserStatsView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))

    override func setUp() {

        super.setUp()
        folderName = String(describing: type(of: userStats))
        userStats.backgroundColor = UIColor(hex: 0x03C8F5)

        self.recordMode = false
    }

    func testCommon() {

        userStats.render(with: (repositories: 12, stars: 1002, languages: 3, medals: 5))
        FBSnapshotVerifyView(userStats)
    }

    func testEmpty() {

        FBSnapshotVerifyView(userStats)
    }

    func testAllNil() {

        userStats.render(with: (repositories: nil, stars: nil, languages: nil, medals: nil))
        FBSnapshotVerifyView(userStats)
    }

    func testLongValues() {

        userStats.render(with: (repositories: 23, stars: 120_453, languages: 3, medals: 8))
        FBSnapshotVerifyView(userStats)
    }
}


