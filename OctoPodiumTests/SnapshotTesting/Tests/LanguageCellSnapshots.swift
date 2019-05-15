//
//  LanguageCellSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 14/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

final class LanguageCellSnapshots: FBSnapshotTestCase {

    typealias SELF = LanguageCellSnapshots

    private static let size = CGSize(width: 30, height: 30)

    override func setUp() {

        super.setUp()
        folderName = String(describing: LanguageCell.self)
        self.recordMode = false
    }

    func testAllCases() {
        let languageCases = ["Language", "R", "Swift", "JAVASCRIPT", "RUBY", "Go", "HTML", "Visual Basic"]
        let count = languageCases.count

        let container = UIStackView(
            frame: CGRect(origin: .zero, size: CGSize(width: 320, height: CGFloat(50 * count)))
        )
        container.spacing = 5
        container.distribution = .fillEqually
        container.backgroundColor = .white
        container.axis = .vertical

        languageCases.enumerated().forEach { i, language in
            let cell = LanguageCell()
            cell.frame = container.frame
            cell.contentView.backgroundColor = .white
            container.addArrangedSubview(cell.contentView)
            cell.render(with: language)
        }

        FBSnapshotVerifyView(container)
    }
}
