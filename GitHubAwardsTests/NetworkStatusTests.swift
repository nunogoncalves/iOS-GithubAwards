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

            context("Raw values") {
                it("expects propper Network Status") {
                    let ok = NetworkStatus(rawValue: 200)
                    expect(ok).to(equal(NetworkStatus.Ok))
                    
                    let offline = NetworkStatus(rawValue: -1009)
                    expect(offline).to(equal(NetworkStatus.Offline))
                    
                    let hostNameNotFound = NetworkStatus(rawValue: -1003)
                    expect(hostNameNotFound).to(equal(NetworkStatus.HostNameNotFound))
                    
                    let couldNotConnectToServer = NetworkStatus(rawValue: -1004)
                    expect(couldNotConnectToServer).to(equal(NetworkStatus.CouldNotConnectToServer))
                    
                    let notFound = NetworkStatus(rawValue: 404)
                    expect(notFound).to(equal(NetworkStatus.NotFound))
                    
                    let serverErrork = NetworkStatus(rawValue: 500)
                    expect(serverErrork).to(equal(NetworkStatus.ServerError))
                    
                    let genericError = NetworkStatus(rawValue: -1)
                    expect(genericError).to(equal(NetworkStatus.GenericError))
                }
            }
            
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
            
            context("error messages") {
                it("ok") {
                    let ok = NetworkStatus.Ok
                    expect(ok.message()).to(equal("Ok"))
                }
                
                it("offline") {
                    let offline = NetworkStatus.Offline
                    expect(offline.message()).to(equal("Connection appears to be offline."))
                }
                it("HostNameNotFound") {
                    let hostNotFound = NetworkStatus.HostNameNotFound
                    expect(hostNotFound.message()).to(equal("There was a technical problem."))
                }
                
                it("Timeout") {
                    let coundlNotConnect = NetworkStatus.CouldNotConnectToServer
                    expect(coundlNotConnect.message()).to(equal("There was a technical problem."))
                }
                
                it("NotFound") {
                    let notFound = NetworkStatus.NotFound
                    expect(notFound.message()).to(equal("The resource you are looking for doesn't exist."))
                }
                
                it("ServerError") {
                    let serverError = NetworkStatus.ServerError
                    expect(serverError.message()).to(equal("There was a technical problem."))
                }
            }
        }
    }
}
