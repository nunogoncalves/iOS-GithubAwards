//
//  MedalDisplaySnapshotTests.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 10/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

final class MedalDisplaySnapshotTests: FBSnapshotTestCase {

    private let medals = MedalDisplayView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))

    override func setUp() {

        super.setUp()
        folderName = String(describing: type(of: medals))
        medals.backgroundColor = .white

        self.recordMode = false
    }

    func testGold() {
        medals.render(with: [.gold])
        FBSnapshotVerifyView(medals)
    }

    func testSilver() {
        medals.render(with: [.silver])
        FBSnapshotVerifyView(medals)
    }

    func testBronze() {
        medals.render(with: [.bronze])
        FBSnapshotVerifyView(medals)
    }

    func testGoldAndSilver() {
        medals.render(with: [.gold, .silver])
        FBSnapshotVerifyView(medals)
    }

    func testGoldAndBronze() {
        medals.render(with: [.gold, .bronze])
        FBSnapshotVerifyView(medals)
    }

    func testSilverAndBronze() {
        medals.render(with: [.silver, .bronze])
        FBSnapshotVerifyView(medals)
    }

    func testAll() {
        medals.render(with: [.gold, .silver, .bronze])
        FBSnapshotVerifyView(medals)
    }
}
