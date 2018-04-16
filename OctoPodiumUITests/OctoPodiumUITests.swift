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

    override func getFolderName() -> String {
        return String(describing: type(of: self))
    }

    override func setUp() {
        super.setUp()

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
            .takeASnapshotForAppStore()
            .goToJavascriptRanking()
            .takeASnapshotForAppStore(named: "02LanguageRankingScreen")
            .goToFacebookProfile()
            .takeASnapshotForAppStore(named: "03FacebookScreen")

        mainTabScreen
            .goToTrendingScreen()
            .verifyScreenView(with: "04TrendingScreen")
            .takeASnapshotForAppStore(named: "04TrendingScreen")

        mainTabScreen
            .goToSettingsScreen()
            .goToGithubAccountScreen()
            .goToAddGithubAccountScreen()
            .verifyScreenView(with: "05AddGitHubAccountScreen")
            .takeASnapshotForAppStore(named: "05AddGitHubAccountScreen")
    }
}
