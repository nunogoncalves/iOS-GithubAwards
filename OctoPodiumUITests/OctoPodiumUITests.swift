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
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLanguagesScreen() {
        let languagesTitle = app.navigationBars.staticTexts["Languages"]
        XCTAssertTrue(languagesTitle.exists, "Should be the title of the first screen")
    }

    func testListOfLanguages() {
//        let app = XCUIApplication()
//        let tabBarsQuery = app.tabBars
//        tabBarsQuery.buttons["Contacts"].tap()
//        
//        let searchForAUserSearchField = app.searchFields["Search for a user"]
//        searchForAUserSearchField.tap()
//        searchForAUserSearchField.typeText("nun")
//        app.buttons["Search"].tap()
//        app.typeText("\n")
//        tabBarsQuery.buttons["Featured"].tap()
//        app.buttons["Try again"].tap()
        
    }
}
