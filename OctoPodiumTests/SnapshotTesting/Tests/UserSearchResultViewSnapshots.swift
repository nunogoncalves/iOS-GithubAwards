//
//  UserSearchResultViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 16/06/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase
import Xtensions

final class UserSearchResultViewSnapthos: FBSnapshotTestCase {

    private let view = UserSearchResultView(frame: 200)

    override func setUp() {

        super.setUp()
        folderName = String(describing: type(of: view))

        self.recordMode = false
    }

    func testFound() {
        view.render(found: true)
        FBSnapshotVerifyView(view)
    }

    func testNotFound() {
        view.render(found: false)
        FBSnapshotVerifyView(view)
    }
}

