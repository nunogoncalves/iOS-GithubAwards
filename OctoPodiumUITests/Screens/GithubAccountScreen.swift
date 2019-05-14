//
//  GithubAccountScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

struct GithubAccountScreen: NavigationBarScreen {

    let app: XCUIApplication
    let testCase: XCTestCase

    let navigationBarIdentifier = ElementName.navigationBarIdentifier

    init(app: XCUIApplication, testCase: XCTestCase) {

        self.app = app
        self.testCase = testCase
        self.waitUntilLoaded()
    }

    func waitUntilLoaded() {

    }

    var addGithubAccountButton: XCUIElement { return navigationBar.buttons[.addGithubAccount] }

    @discardableResult
    func goToAddGithubAccountScreen() -> GithubLoginScreen {
        addGithubAccountButton.tap()
        return GithubLoginScreen(app: app, testCase: testCase)
    }
}

extension ElementName {

    static let navigationBarIdentifier = "Github Account"
    static let addGithubAccount = "Add"
}
