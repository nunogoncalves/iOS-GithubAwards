//
//  UserCellSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 15/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

final class UserCellSnapshots: FBSnapshotTestCase, ImageMocker {

    override func setUp() {

        super.setUp()
        mockImages()
        folderName = "UserCell"//String(describing: UserRankingCell.self)
        self.recordMode = false
    }

    func testRegular() {

        let user = User(login: "nunogoncalves", avatarUrl: "https://avatars.githubusercontent.com/u/9892522.jpeg")
        user.starsCount = 380
        user.rankings = [
            Ranking(
                world: WorldRanking(position: 4, total: 120),
                country: nil,
                city: nil,
                language: "Swift",
                repositories: 20,
                stars: 560
            )
        ]
        let userPresenter = UserPresenter(user: user)

        let container = UIStackView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 105)))
        container.axis = .vertical
        container.spacing = 5
        container.distribution = .fillEqually

        let cell = UserRankingCell.usingAutoLayout()
        cell.render(with: userPresenter)

        waitSync(for: .loadingTime)

        let user1 = User(login: "nunogoncalves", avatarUrl: "https://avatars.githubusercontent.com/u/9892522.jpeg")
        user1.starsCount = 380
        user1.rankings = [
            Ranking(
                world: WorldRanking(position: 3, total: 1200),
                country: CountryRanking(name: "Portugal", position: 2, total: 420),
                city: CityRanking(name: "Lisbon", position: 1, total: 120),
                language: "Swift",
                repositories: 20,
                stars: 560
            )
        ]
        let userPresenter1 = UserPresenter(user: user1)

        let cell1 = UserRankingCell.usingAutoLayout()
        cell1.render(with: userPresenter1)
        container.addArrangedSubview(cell1.contentView)
        container.addArrangedSubview(cell.contentView)

        FBSnapshotVerifyView(container)
    }
}

