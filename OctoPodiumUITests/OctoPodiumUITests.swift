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
        setupSnapshot(app)
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLanguagesScreen() {

        let app = XCUIApplication()
        
        let expectation = expectationWithDescription("High expectations")
        expectation.fulfill()
        
        waitForExpectationsWithTimeout(3, handler: nil)
        
        snapshot("01LanguagesScreen")
        
        let tablesQuery = app.tables
        tablesQuery.cells.staticTexts["JavaScript"].tap()
        
        snapshot("02LanguageRankingScreen")
        
        tablesQuery.cells.staticTexts["facebook"].tap()
        
        snapshot("03FacebookScreen")

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Trending"].tap()
        
        let expectation1 = expectationWithDescription("High expectations")
        expectation1.fulfill()
    
        waitForExpectationsWithTimeout(8, handler: { _ in
            snapshot("04TrendingScreen")
        })

        tabBarsQuery.buttons["More"].tap()
        
        let cells = app.tables.cells
        cells.elementBoundByIndex(0).tap()
        
        app.navigationBars["Github Account"].buttons["Add"].tap()
        snapshot("05AddGitHubAccountScreen")
        
    }
}
