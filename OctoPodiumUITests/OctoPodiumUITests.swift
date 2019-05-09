//
//  OctoPodiumUITests.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import FBSnapshotTestCase

class OctoPodiumUITests: FBSnapshotTestCase {
    
    private let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        recordMode = false
        folderName = String(describing: type(of: self))
        setupSnapshot(app: app)
        continueAfterFailure = true

        app.launchArguments.append(UITestingConstants.uiTestingMode)
        app.launch()
    }
    
    func testBasicNavigation() {

        let mainTabScreen = MainTabScreen(app: app, testCase: self)

        mainTabScreen
            .goToLanguagesScreen()
            .verifyScreenView(with: "01LanguagesScreen")
            .goToJavascriptRanking()
            .verifyScreenView(with: "02LanguageRankingScreen", snapshotToAppStore: true)
            .goToFacebookProfile()
            .verifyScreenView(with: "03FacebookScreen", snapshotToAppStore: true)

        mainTabScreen
            .goToTrendingScreen()
            .verifyScreenView(with: "04TrendingScreen", snapshotToAppStore: true)

        mainTabScreen
            .goToSettingsScreen()
            .goToGithubAccountScreen()
            .goToAddGithubAccountScreen()
            .verifyScreenView(with: "05AddGitHubAccountScreen", snapshotToAppStore: true)
    }
}
