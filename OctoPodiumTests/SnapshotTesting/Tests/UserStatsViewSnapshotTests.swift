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

    override func getFolderName() -> String {

        return String(describing: type(of: userStats))
    }

    override func setUp() {

        super.setUp()
        userStats.backgroundColor = UIColor(hex: 0x03C8F5)

//        self.recordMode = true
    }

    func testCommon() {

        userStats.render(with: (repositories: 12, stars: 1002, languages: 3, medals: 5))
        FBSnapshotVerifyView(userStats)
    }
}


