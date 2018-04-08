//
//  UserDetailsScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

struct UserDetailsScreen: Screen {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(app: XCUIApplication, testCase: XCTestCase) {

        self.app = app
        self.testCase = testCase
        self.waitUntilLoaded()
    }

    func waitUntilLoaded() {

    }
}
