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

    private var table: XCUIElementQuery { return app.tables }
    private var searchField: XCUIElement { return app.searchFields[.filter] }
    private var clearSearch: XCUIElement { return searchField.buttons[.clear] }
    private var cancelSearch: XCUIElement { return searchField.buttons[.cancelSearch] }
    private var searchButton: XCUIElement { return app.buttons[.search] }
    private var javascriptText: XCUIElement { return table.cells.staticTexts[.javascript] }

    func waitUntilLoaded() {
        testCase.waitForAppearance(of: javascriptText, for: .twoSeconds)
        XCTAssertNotNil(searchField)
    }

    func search(for language: String) -> LanguagesScreen {
        searchField.tap()
        searchField.typeText(language)
        return self
    }

    func goToJavascriptRanking() -> LanguageRankingScreen {
        javascriptText.tap()
        return LanguageRankingScreen(app: app, testCase: testCase)
    }
}

private extension ElementName {
    static let javascript = "JavaScript"
    static let filter = "Filter"
    static let clear = "Clear text"
    static let search = "Search"
    static let cancelSearch = "Cancel"
}
