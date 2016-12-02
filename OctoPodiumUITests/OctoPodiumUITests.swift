//
//  OctoPodiumUITests.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest

class OctoPodiumUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        setupSnapshot(app: app)
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLanguagesScreen() {

        let app = XCUIApplication()
        
        let expectation0 = expectation(description: "High expectations")
        expectation0.fulfill()
        
        waitForExpectations(timeout: 3, handler: nil)
        
        snapshot(name: "01LanguagesScreen")
        
        let tablesQuery = app.tables
        tablesQuery.cells.staticTexts["JavaScript"].tap()
        
        snapshot(name: "02LanguageRankingScreen")
        
        tablesQuery.cells.staticTexts["facebook"].tap()
        
        snapshot(name: "03FacebookScreen")

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Trending"].tap()
        
        let expectation1 = expectation(description: "High expectations")
        expectation1.fulfill()
    
        waitForExpectations(timeout: 8, handler: { _ in
            snapshot(name: "04TrendingScreen")
        })

        tabBarsQuery.buttons["More"].tap()
        
        let cells = app.tables.cells
        cells.element(boundBy: 0).tap()
        
        app.navigationBars["Github Account"].buttons["Add"].tap()
        snapshot(name: "05AddGitHubAccountScreen")
        
    }
}
