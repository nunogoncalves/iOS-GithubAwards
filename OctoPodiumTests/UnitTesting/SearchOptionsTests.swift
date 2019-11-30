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
        searchOptions = SearchOptions(language: "javascript", locationType: .world, page: 1)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNoLanguageNorLocation() {
        let expected = "language=javascript&type=world&page=1"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testLanguage() {
        searchOptions.language = "Swift"
        let expected = "language=swift&type=world&page=1"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testNoCity() {
        let expected = "language=javascript&type=world&page=1"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testCity() {
        searchOptions.locationType = .city(name: "Lisbon")
        let expected = "language=javascript&type=city&city=Lisbon&page=1"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testNoCountry() {
        searchOptions.locationType = .country(name: "san francisco")
        let expected = "language=javascript&type=country&country=san%20francisco&page=1"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testCountry() {
        searchOptions.language = "Swift"
        searchOptions.locationType = .country(name: "Portugal")

        let expected = "language=swift&type=country&country=Portugal&page=1"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testPage() {
        searchOptions.page = 3

        let expected = "language=javascript&type=world&page=3"
        let got = urlQuery(from: searchOptions.queryItems)
        XCTAssertEqual(expected, got, "Expected \(expected), got \(got)")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func urlQuery(from query: [URLQueryItem]) -> String {
        var components = URLComponents(url: URL(string: "www.gitawaards.com")!, resolvingAgainstBaseURL: true)!
        components.queryItems = query
        return components.url!.query!
    }
}
