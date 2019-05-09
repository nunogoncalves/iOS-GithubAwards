//
//  GithubButtonSnapshotTests.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 30/03/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

@testable import OctoPodium
import FBSnapshotTestCase

final class GithubButtonSnapshotTests: FBSnapshotTestCase {

    let githubButton = NewGithubButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))

    override func setUp() {

        super.setUp()
        folderName = "GithubButton"
        self.recordMode = false
    }

    func testLoading() {

        githubButton.render(with: .full(image: #imageLiteral(resourceName: "StarDark"), title: "Stars", value: "--"))
        githubButton.render(with: .startLoading)
        FBSnapshotVerifyView(githubButton)
    }

    func testSmallAmountOfStars() {

        githubButton.render(with: .full(image: #imageLiteral(resourceName: "StarDark"), title: "Stars", value: "10"))
        githubButton.render(with: .stopLoading)
        FBSnapshotVerifyView(githubButton)
    }

    func testBigAmoutOfStars() {

        let githubButton = NewGithubButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        githubButton.render(with: .full(image: #imageLiteral(resourceName: "StarDark"), title: "Stars", value: "1000000"))
        githubButton.render(with: .stopLoading)
        FBSnapshotVerifyView(githubButton)
    }

    func testSmallAmountOfFork() {

        githubButton.render(with: .full(image: #imageLiteral(resourceName: "ForkDark"), title: "Forks", value: "10"))
        githubButton.render(with: .stopLoading)

        FBSnapshotVerifyView(githubButton)
    }

    func testTinyText() {

        githubButton.render(with: .full(image: #imageLiteral(resourceName: "StarDark"), title: "Hi", value: "10"))
        githubButton.render(with: .stopLoading)
        FBSnapshotVerifyView(githubButton)
    }
}
