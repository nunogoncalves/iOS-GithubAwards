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

    let githubButton = GithubButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))

    override func getFolderName() -> String {

        return String(describing: type(of: githubButton))
    }

    override func setUp() {

        super.setUp()
//        self.recordMode = true
    }

    func testLoading() {

        FBSnapshotVerifyView(githubButton)
    }

    func testSmallAmountOfStars() {

        githubButton.setName("Stars")
        githubButton.setValue("10")
        FBSnapshotVerifyView(githubButton)
    }

    func testBigAmoutOfStars() {

        githubButton.setName("Stars")
        githubButton.setValue("1000000")
        FBSnapshotVerifyView(githubButton)
    }

    func testSmallAmountOfFork() {

        githubButton.setImage(#imageLiteral(resourceName: "ForkDark"))
        githubButton.setName("Fork")
        githubButton.setValue("10")
        FBSnapshotVerifyView(githubButton)
    }

    func testTinyText() {

        githubButton.setName("Hi")
        githubButton.setValue("10")
        FBSnapshotVerifyView(githubButton)
    }
}
