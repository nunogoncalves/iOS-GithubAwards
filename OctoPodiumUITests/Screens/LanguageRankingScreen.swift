//
//  LanguageRankingScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import Foundation

import XCTest

struct LanguageRankingScreen: Screen {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(app: XCUIApplication, testCase: XCTestCase) {

        self.app = app
        self.testCase = testCase
        self.waitUntilLoaded()
    }

    func waitUntilLoaded() {
    }

    private var table: XCUIElementQuery {
        return app.tables
    }

    private var facebookText: XCUIElement {

        return table.cells.staticTexts["facebook"]
    }

    func goToFacebookProfile() -> UserDetailsScreen {

        facebookText.tap()

        return UserDetailsScreen(app: app, testCase: testCase)
    }
}

private extension ElementName {

    static let facebook = "facebook"
}
