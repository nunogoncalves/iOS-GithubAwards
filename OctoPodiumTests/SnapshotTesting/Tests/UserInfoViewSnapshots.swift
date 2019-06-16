//
//  UserInfoViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 19/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

final class UserInfoViewSnapshots: FBSnapshotTestCase, ImageMocker {

    private let userInfoView = UserInfoView.usingAutoLayout()

    private let user: User = {
        let user = User(login: "nunogoncalves", avatarUrl: "https://avatars.githubusercontent.com/u/9892522.jpeg")
        user.starsCount = 380
        user.city = "San Francisco"
        user.country = "United States"
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
        return user
    }()

    override func setUp() {

        super.setUp()
        folderName = String(describing: UserInfoView.self)
        self.recordMode = false
        mockImages()
    }

    func testCommon() {

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 391))
        container.backgroundColor = .white
        container.addSubview(userInfoView)

        userInfoView.constrain(referringTo: container, bottom: nil)

        userInfoView.backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.6745098039, blue: 0.6745098039, alpha: 1)
        userInfoView.render(with: UserPresenter(user: user))
        userInfoView.layoutIfNeeded()
        userInfoView.constrain(height: 50)
        userInfoView.render(with: 50)

        let userInfoView1 = UserInfoView.usingAutoLayout()
        container.addSubview(userInfoView1)
        userInfoView1.constrain(referringTo: container, top: nil, bottom: nil)
        userInfoView1.top(==, userInfoView.bottomAnchor, 10)

        userInfoView1.backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.6745098039, blue: 0.6745098039, alpha: 1)
        userInfoView1.render(with: UserPresenter(user: user))
        userInfoView1.layoutIfNeeded()
        userInfoView1.constrain(height: 120)
        userInfoView1.render(with: 120)

        let userInfoView2 = UserInfoView.usingAutoLayout()
        container.addSubview(userInfoView2)
        userInfoView2.constrain(referringTo: container, top: nil, bottom: nil)
        userInfoView2.top(==, userInfoView1.bottomAnchor, 10)

        userInfoView2.backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.6745098039, blue: 0.6745098039, alpha: 1)
        userInfoView2.layoutIfNeeded()
        userInfoView2.render(with: UserPresenter(user: user))

        waitSync(for: 0.3)
        FBSnapshotVerifyView(container)
    }
}
