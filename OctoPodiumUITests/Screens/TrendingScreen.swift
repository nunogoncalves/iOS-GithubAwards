//
//  TrendingScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

struct TrendingScreen: NavigationBarScreen {

    let app: XCUIApplication
    let testCase: XCTestCase

    var navigationBarIdentifier = String.navBarId

    private var dailyElement: XCUIElement {

        return navigationBar.buttons[.daily]
    }

    private var weeklyElement: XCUIElement {

        return navigationBar.buttons[.weekly]
    }

    private var monthlyElement: XCUIElement {

        return navigationBar.buttons[.monthly]
    }

    private var vueJSElement: XCUIElement {

        return app.tables.staticTexts["  Minimalistic Vue-powered static site generator"]
    }

    init(app: XCUIApplication, testCase: XCTestCase) {

        self.app = app
        self.testCase = testCase
        self.waitUntilLoaded()
    }

    func waitUntilLoaded() {

        XCTAssert(dailyElement.exists)
        XCTAssert(weeklyElement.exists)
        XCTAssert(monthlyElement.exists)

        testCase.waitForAppearance(of: vueJSElement)
    }
}

private extension String {

    static let navBarId = "vuepress"
    static let daily = "Daily"
    static let weekly = "Weekly"
    static let monthly = "Monthy"
}
