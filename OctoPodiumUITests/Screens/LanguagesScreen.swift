//
//  LanguagesScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

struct LanguagesScreen: Screen {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(app: XCUIApplication, testCase: XCTestCase) {

        self.app = app
        self.testCase = testCase
        self.waitUntilLoaded()
    }

    private var table: XCUIElementQuery {
        return app.tables
    }

    private var javascriptText: XCUIElement {

        return table.cells.staticTexts[.javascript]
    }

    func waitUntilLoaded() {

        testCase.waitForAppearance(of: javascriptText, for: .twoSeconds)
    }

    func goToJavascriptRanking() -> LanguageRankingScreen {
        
        javascriptText.tap()

        return LanguageRankingScreen(app: app, testCase: testCase)
    }
}

private extension ElementName {

    static let javascript = "JavaScript"
}
