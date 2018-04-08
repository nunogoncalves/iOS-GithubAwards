//
//  OctoPodiumUITests.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import FBSnapshotTestCase

class OctoPodiumUITests: FBSnapshotTestCase {
    
    let app = XCUIApplication()

    override func getFolderName() -> String {

        return String(describing: type(of: self))
    }

    override func setUp() {
        super.setUp()
        setupSnapshot(app: app)
        continueAfterFailure = true
        app.launch()
    }
    
    func testBasicNavigationScreen() {

        let mainTabScreen = MainTabScreen(app: app, testCase: self)

        mainTabScreen
            .goToLanguagesScreen()
            .takeASnapshot(named: "01LanguagesScreen")
            .verifyScreenView(with: "01LanguagesScreen")
            .goToJavascriptRanking()
            .takeASnapshot(named: "02LanguageRankingScreen")
            .goToFacebookProfile()
            .takeASnapshot(named: "03FacebookScreen")

        mainTabScreen
            .goToTrendingScreen()
            .takeASnapshot(named: "04TrendingScreen")

        mainTabScreen
            .goToSettingsScreen()
            .goToGithubAccountScreen()
            .goToAddGithubAccountScreen()
            .takeASnapshot(named: "05AddGitHubAccountScreen")
            .verifyScreenView(with: "05AddGitHubAccountScreen")
    }
}
