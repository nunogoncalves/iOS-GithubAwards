//
//  GithubLoadingViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 16/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

@testable import OctoPodium
import FBSnapshotTestCase

final class GithubLoadingViewSnapshots: FBSnapshotTestCase {

    override func setUp() {

        super.setUp()
        folderName = GithubLoadingView.name
        self.recordMode = false
    }

    func testAllCases() {

        let count = 7

        let container = UIStackView(
            frame: CGRect(origin: .zero, size: CGSize(width: CGFloat(35 * count), height: 30))
        )
        container.spacing = 5
        container.distribution = .fillEqually
        container.axis = .horizontal

        (0..<count).forEach { i in
            let loading = GithubLoadingView.usingAutoLayout()
            loading.backgroundColor = .white
            loading.fix(at: 10 * i, offset: 50)
            container.addArrangedSubview(loading)
        }

        FBSnapshotVerifyView(container)
    }
}
