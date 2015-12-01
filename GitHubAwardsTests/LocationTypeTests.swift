//
//  LocationTypeTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 01/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import GitHubAwards

class LocationTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIsCity() {
        let type = LocationType.getTypeFor("city")
        XCTAssert(type == .City, "Expected .City, got \(type)")
    }
    
    func testIsCityCase() {
        let type = LocationType.getTypeFor("CITY")
        XCTAssert(type == .City, "Expected .City, got \(type)")
    }
    
    func testIsCountry() {
        let type = LocationType.getTypeFor("country")
        XCTAssert(type == .Country, "Expected .Country, got \(type)")
    }
    
    func testIsCountryCase() {
        let type = LocationType.getTypeFor("COUNTRY")
        XCTAssert(type == .Country, "Expected .Country, got \(type)")
    }
    
    func testIsWorld() {
        let type = LocationType.getTypeFor("world")
        XCTAssert(type == .World, "Expected .World, got \(type)")
    }
    
    func testIsWorldCase() {
        let type = LocationType.getTypeFor("WORLD")
        XCTAssert(type == .World, "Expected .World, got \(type)")
    }
    
    func testIsWorldRandomRawValue() {
        let type = LocationType.getTypeFor("RaNdOmTyPe")
        XCTAssert(type == .World, "Expected .World, got \(type)")
    }
    
    func testHasNameCity() {
        let type = LocationType.City
        XCTAssert(type.hasName(), "Expected .City to have a name.")
    }
    
    func testHasNameCountry() {
        let type = LocationType.Country
        XCTAssert(type.hasName(), "Expected .Country to have a name.")
    }
    
    func testHasNameWorld() {
        let type = LocationType.World
        XCTAssert(!type.hasName(), "Expected .World not to have a name.")
    }
}
