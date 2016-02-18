//
//  StringTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
import XCTest

@testable import OctoPodium

class StringTests: QuickSpec {
    
    override func spec() {
        describe("String") {
            context("Join") {
                it("returns two strings joined by ','") {
                    let result = String.join(", ", "Hello", "World")
                    let expected = "Hello, World"
                    XCTAssertEqual(result, expected, "Expected \(expected), and got \(result)")
                }
                
                it("returns just the first string") {
                    let result = String.join(", ", "Hello", nil)
                    let expected = "Hello"
                    XCTAssertEqual(result, expected, "Expected \(expected), and got \(result)")
                }
                
                it("returns just the second string") {
                    let result = String.join(", ", nil, "World")
                    let expected = "World"
                    XCTAssertEqual(result, expected, "Expected \(expected), and got \(result)")
                }
                
                it("returns an empty string") {
                    let result = String.join(", ", nil, nil)
                    let expected = ""
                    XCTAssertEqual(result, expected, "Expected \(expected), and got \(result)")
                }

                it("returns substring until when exists") {
                    let result = "hello,world".substringAfter(",")
                    let expected = "world"
                    expect(result).to(equal(Optional(expected)))
                }
                
                it("returns empty when substring doesnt exist") {
                    let result = "hello,world".substringAfter(", ")
                    expect(result).to(beNil())
                }
            }
        }
    }
}
