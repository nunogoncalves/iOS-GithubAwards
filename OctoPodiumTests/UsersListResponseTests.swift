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

class UsersListResponseTests: QuickSpec {
    
    override func spec() {
        var usersListResponse: UsersListResponse!
        let nuno = User(login: "Nuno", avatarUrl: "avatar")
        let katrina = User(login: "Katrina", avatarUrl: "avatar")
        let bianca = User(login: "Bianca", avatarUrl: "avatar")
        let xana = User(login: "Xana", avatarUrl: "avatar")
        
        describe("User list response") {
            
            context("list of users") {
                beforeEach {
                    usersListResponse = UsersListResponse(users: [nuno, katrina, bianca, xana], paginator: Paginator())
                }
                
                it("should contain 4 users") {
                    expect(usersListResponse.users.count).to(equal(4))
                }
                
                it("has Bianca as the third user") {
                    expect(usersListResponse.users[2].login).to(equal("Bianca"))
                }
            }
            
        }
    }
    
}
