//
//  NetworkStatusTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//
import Quick
import Nimble
import XCTest
@testable import GitHubAwards

class NetworkStatusTests : QuickSpec {
    override func spec() {
        describe("NetworkStatusTests") {

            context("No technical status") {
                it("GenericError") {
                    let notFound = NetworkStatus.NotFound
                    expect(notFound.isTechnicalError()).to(equal(false))
                }

            }
            
            context("technical status") {
                it("generic error") {
                    let notFound = NetworkStatus.GenericError
                    expect(notFound.isTechnicalError()).to(equal(true))
                }
                
                
                it("generic error") {
                    let notFound = NetworkStatus.GenericError
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("ok") {
                    let notFound = NetworkStatus.Ok
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("offline error") {
                    let notFound = NetworkStatus.Offline
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("host name not found error") {
                    let notFound = NetworkStatus.HostNameNotFound
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("could not connect error") {
                    let notFound = NetworkStatus.CouldNotConnectToServer
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("server error") {
                    let notFound = NetworkStatus.ServerError
                    expect(notFound.isTechnicalError()).to(equal(true))
                }
               
            }
        }
    }
}
