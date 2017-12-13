//
//  UsersListResponseTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
import XCTest

@testable import OctoPodium

class PageTests: QuickSpec {
    
    override func spec() {
        var page: Page<User>!

        let nuno = User(login: "Nuno", avatarUrl: "avatar")
        let katrina = User(login: "Katrina", avatarUrl: "avatar")
        let bianca = User(login: "Bianca", avatarUrl: "avatar")
        let xana = User(login: "Xana", avatarUrl: "avatar")
        
        describe("User list response") {
            
            context("list of users") {
                beforeEach {
                    page = Page(items: [nuno, katrina, bianca, xana],
                                currentPage: 1,
                                totalPages: 3,
                                totalCount: 10)
                }
                
                it("should contain 4 users") {
                    expect(page.items.count).to(equal(4))
                }
                
                it("has Bianca as the third user") {
                    expect(page.items[2].login).to(equal("Bianca"))
                }

                it("has more pages") {
                    expect(page.hasMorePages).to(beTrue())
                }
            }
            
        }
    }
    
}
