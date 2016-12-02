////
////  LocationTypeTests.swift
////  OctoPodium
////
////  Created by Nuno Gonçalves on 01/12/15.
////  Copyright © 2015 Nuno Gonçalves. All rights reserved.
////
//
//import Quick
//import Nimble
//import XCTest
//
//@testable import OctoPodium
//
//import OctoPodium
//
//class LocationTypeTests: QuickSpec {
//    
//    override func spec() {
//        
//        describe("a city") {
//            it("builds a city location type from city string") {
//                let type = LocationType.getTypeFor("city")
//                XCTAssertEqual(type, LocationType.City, "Expected .City, got \(type)")
//            }
//            
//            it("builds a city location type from CITY string") {
//                let type = LocationType.getTypeFor("city")
//                XCTAssertEqual(type, LocationType.City, "Expected .City, got \(type)")
//            }
//            
//            it("builds a city location type from cItY string") {
//                let type = LocationType.getTypeFor("cItY")
//                XCTAssertEqual(type, LocationType.City, "Expected .City, got \(type)")
//            }
//            
//            it("has name") {
//                let type = LocationType.City
//                XCTAssertEqual(type.hasName(), true, "Expected .City to have a name.")
//            }
//        }
//        
//        describe("a country") {
//            it("builds a city location type from country string") {
//                let type = LocationType.getTypeFor("country")
//                XCTAssertEqual(type, LocationType.Country, "Expected .Country, got \(type)")
//            }
//            
//            it("builds a city location type from COUNTRY string") {
//                let type = LocationType.getTypeFor("COUNTRY")
//                XCTAssertEqual(type, LocationType.Country, "Expected .Country, got \(type)")
//            }
//            
//            it("builds a city location type from cOuNtRy string") {
//                let type = LocationType.getTypeFor("cOuNtRy")
//                XCTAssertEqual(type, LocationType.Country, "Expected .Country, got \(type)")
//            }
//            
//            it("has name") {
//                let type = LocationType.Country
//                XCTAssertEqual(type.hasName(), true, "Expected .Country to have a name.")
//            }
//        }
//        
//        describe("the world") {
//            it("builds a world location type from world string") {
//                let type = LocationType.getTypeFor("world")
//                XCTAssertEqual(type, LocationType.World, "Expected .World, got \(type)")
//            }
//            
//            it("builds a world location type from WORLD string") {
//                let type = LocationType.getTypeFor("WORLD")
//                XCTAssertEqual(type, LocationType.World, "Expected .World, got \(type)")
//            }
//            
//            it("builds a world location type from wORlD string") {
//                let type = LocationType.getTypeFor("wORlD")
//                XCTAssertEqual(type, LocationType.World, "Expected .World, got \(type)")
//            }
//            
//            it("builds a world location type from a RANDOM_STR string") {
//                let type = LocationType.getTypeFor("RANDOM_STR")
//                XCTAssertEqual(type, LocationType.World, "Expected .World, got \(type)")
//            }
//            
//            it("doesn't have name") {
//                let type = LocationType.World
//                XCTAssertEqual(type.hasName(), false, "Expected .World not to have a name.")
//            }
//        }
//    }
//}
