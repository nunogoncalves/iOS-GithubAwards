//
//  AlertViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 15/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

final class AlertViewSnapshots: FBSnapshotTestCase {

    override func setUp() {

        super.setUp()
        folderName = AlertView.name
        self.recordMode = false
    }

    func testAllCases() {

        let container = UIStackView(
            frame: CGRect(origin: .zero, size: CGSize(width: 375, height: CGFloat(85 * 3)))
        )
        container.spacing = 5
        container.distribution = .fillEqually
        container.axis = .vertical

        let warning = AlertView.usingAutoLayout()
        warning.render(with: .warning("This is a warning"))
        container.addArrangedSubview(warning)

        let error = AlertView.usingAutoLayout()
        error.render(with: .error("This is an error"))
        container.addArrangedSubview(error)

        let success = AlertView.usingAutoLayout()
        success.render(with: .success("This is a success"))
        container.addArrangedSubview(success)

        FBSnapshotVerifyView(container)
    }
}
