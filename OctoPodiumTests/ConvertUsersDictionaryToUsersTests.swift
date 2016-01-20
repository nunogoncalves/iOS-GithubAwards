//
//  ConvertUsersDictionaryToUsers.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import OctoPodium

class ConvertUsersDictionaryToUsersTests: XCTestCase {

    let dic = [
        "users" : [
            [
                "login" : "nunogoncalves",
                "gravatar_url": "avatar_url",
            ],
            [
                "login" : "ironman",
                "gravatar_url": "http://p1.pichost.me/i/72/1967552.jpg",
            ]
        ]
    ]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperUsersCount() {
        let converter = ConvertUsersDictionaryToUsers(data: dic)
        XCTAssertEqual(converter.users.count, 2)
    }
    
    func testProperUsersFields() {
        let converter = ConvertUsersDictionaryToUsers(data: dic)
        let users = converter.users
        let nuno = users[0]
        let ironMan = users[1]
        XCTAssertEqual(nuno.login!, "nunogoncalves")
        XCTAssertEqual(nuno.avatarUrl!, "avatar_url")
        XCTAssertEqual(ironMan.login!, "ironman")
        XCTAssertEqual(ironMan.avatarUrl!, "http://p1.pichost.me/i/72/1967552.jpg")
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
