//
//  MainTabBarScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

enum TabItem: Int {

    case languages = 0
    case users
    case trending
    case more
}

struct MainTabScreen: Screen {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(app: XCUIApplication, testCase: XCTestCase) {

        self.app = app
        self.testCase = testCase
        self.waitUntilLoaded()
    }

    func waitUntilLoaded() {

        XCTAssert(languagesTab.exists)
        XCTAssert(usersTab.exists)
        XCTAssert(trendingTab.exists)
        XCTAssert(moreTab.exists)
    }

    var languagesTab: XCUIElement { return tab(.languages) }
    var usersTab: XCUIElement { return tab(.users) }
    var trendingTab: XCUIElement { return tab(.trending) }
    var moreTab: XCUIElement { return tab(.more) }

    private func tab(_ item: TabItem) -> XCUIElement {

        return tabBar.element(boundBy: item.rawValue)
    }

    var tabBar: XCUIElementQuery {

        return app.tabBars.children(matching: .button)
    }

    private func goToTab(_ tabItem: TabItem) {

        tabElement(for: tabItem).tap()
    }

    private func tabElement(for tabItem: TabItem) -> XCUIElement {

        switch tabItem {

        case .languages: return languagesTab
        case .users: return usersTab
        case .trending: return trendingTab
        case .more: return moreTab
        }
    }

    @discardableResult
    func goToLanguagesScreen() -> LanguagesScreen {

        languagesTab.tap()

        return LanguagesScreen(app: app, testCase: testCase)
    }

    @discardableResult
    func goToTrendingScreen() -> TrendingScreen {

        trendingTab.tap()

        return TrendingScreen(app: app, testCase: testCase)
    }

    @discardableResult
    func goToSettingsScreen() -> SettingsScreen {

        moreTab.tap()

        return SettingsScreen(app: app, testCase: testCase)
    }
}

extension ElementName {

    static let languages = "Languages"
    static let users = "Users"
    static let trending = "Trending"
    static let more = "More"
}

