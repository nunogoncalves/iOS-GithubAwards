//
//  SearchOptionsTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import OctoPodium

class SearchOptionsTests: XCTestCase {
    
    var searchOptions: SearchOptions!
    
    override func setUp() {
        super.setUp()
        searchOptions = SearchOptions()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNoLanguageNorLocation() {
        let expected = "language=javascript&type=world&page=1"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testLanguage() {
        searchOptions.language = "Swift"
        let expected = "language=swift&type=world&page=1"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testNoCity() {
        let expected = "language=javascript&type=world&page=1"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testCity() {
        searchOptions.locationType = .City
        searchOptions.location = "Lisbon"
        let expected = "language=javascript&city=lisbon&type=city&page=1"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testNoCountry() {
        searchOptions.locationType = .Country
        let expected = "language=javascript&country=san francisco&type=country&page=1"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testCountry() {
        searchOptions.language = "Swift"
        searchOptions.locationType = .Country
        searchOptions.location = "Portugal"
        
        let expected = "language=swift&country=portugal&type=country&page=1"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testPage() {
        searchOptions.page = 3
        
        let expected = "language=javascript&type=world&page=3"
        let got = searchOptions.urlParams()
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
