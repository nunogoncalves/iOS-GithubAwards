//
//  SearchOptionsTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//


import XCTest
@testable import GitHubAwards

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
        let expected = "language=JavaScript&type=world"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testLanguage() {
        searchOptions.language = "Swift"
        let expected = "language=Swift&type=world"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testNoCity() {
        let expected = "language=JavaScript&type=world"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testCity() {
        searchOptions.locationType = "city"
        searchOptions.location = "Lisbon"
        let expected = "language=JavaScript&city=Lisbon&type=city"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testNoCountry() {
        searchOptions.locationType = "country"
        let expected = "language=JavaScript&country=San Francisco&type=country"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testCountry() {
        searchOptions.language = "Swift"
        searchOptions.locationType = "country"
        searchOptions.location = "Portugal"
        
        let expected = "language=Swift&country=Portugal&type=country"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testPage() {
        searchOptions.page = 3
        
        let expected = "language=JavaScript&type=world&page=3"
        let got = searchOptions.urlEncoded()
        assert(expected == got, "Expected \(expected), got \(got)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
