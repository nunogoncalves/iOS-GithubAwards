//
//  LanguageImageViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 14/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

@testable import OctoPodium
import FBSnapshotTestCase

final class LanguageImageViewSnapshots: FBSnapshotTestCase {

    typealias SELF = LanguageImageViewSnapshots

    private static let size = CGSize(width: 30, height: 30)

    override func setUp() {

        super.setUp()
        folderName = String(describing: LanguageImageView.self)
        self.recordMode = false
    }

    func testAllCases() {
        let languageCases = ["", "Language", "L", "A", "Swift", "JAVASCRIPT", "RUBY", "Go"]
        let count = languageCases.count

        let container = UIStackView(frame: CGRect(origin: .zero, size: CGSize(width: CGFloat(35 * count), height: 30)))
        container.spacing = 5
        container.distribution = .fillEqually
        container.backgroundColor = .white

        languageCases.enumerated().forEach { i, language in
            let view = LanguageImageView.usingAutoLayout()
            view.render(with: language)
            container.addArrangedSubview(view)
        }

        FBSnapshotVerifyView(container)
    }
}


