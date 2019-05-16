//
//  LanguageTitleViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 14/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

@testable import OctoPodium
import FBSnapshotTestCase

final class LanguageTitleViewSnapshots: FBSnapshotTestCase {

    typealias SELF = LanguageTitleViewSnapshots

    private static let size = CGSize(width: 30, height: 30)

    override func setUp() {

        super.setUp()
        folderName = String(describing: LanguageTitleView.self)
        self.recordMode = false
    }

    func testAllCases() {
        let languageCases = ["Language", "R", "Swift", "JAVASCRIPT", "RUBY", "Go", "HTML", "Visual Basic"]
        let count = languageCases.count

        let container = UIStackView(
            frame: CGRect(origin: .zero, size: CGSize(width: 200, height: CGFloat(50 * count)))
        )
        container.spacing = 5
        container.distribution = .fillEqually
        container.axis = .vertical

        languageCases.enumerated().forEach { i, language in

            let view = LanguageTitleView.usingAutoLayout()
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            container.addArrangedSubview(view)
            view.render(with: language)
        }

        FBSnapshotVerifyView(container)
    }
}

