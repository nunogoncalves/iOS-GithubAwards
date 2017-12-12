//
//  NetworkStatusTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//
import Quick
import Nimble
import XCTest

@testable import OctoPodium

class NetworkStatusTests : QuickSpec {
    override func spec() {
        describe("NetworkStatusTests") {

            context("Raw values") {
                it("expects propper Network Status") {
                    let ok = NetworkStatus(rawValue: 200)
                    expect(ok).to(equal(NetworkStatus.ok))
                    
                    let offline = NetworkStatus(rawValue: -1009)
                    expect(offline).to(equal(NetworkStatus.offline))
                    
                    let hostNameNotFound = NetworkStatus(rawValue: -1003)
                    expect(hostNameNotFound).to(equal(NetworkStatus.hostNameNotFound))
                    
                    let couldNotConnectToServer = NetworkStatus(rawValue: -1004)
                    expect(couldNotConnectToServer).to(equal(NetworkStatus.couldNotConnectToServer))
                    
                    let notFound = NetworkStatus(rawValue: 404)
                    expect(notFound).to(equal(NetworkStatus.notFound))
                    
                    let serverErrork = NetworkStatus(rawValue: 500)
                    expect(serverErrork).to(equal(NetworkStatus.serverError))
                    
                    let genericError = NetworkStatus(rawValue: -1)
                    expect(genericError).to(equal(NetworkStatus.genericError))
                }
            }
            
            context("No technical status") {
                it("GenericError") {
                    let notFound = NetworkStatus.notFound
                    expect(notFound.isTechnicalError()).to(equal(false))
                }
           }
            
            context("technical status") {
                it("generic error") {
                    let notFound = NetworkStatus.genericError
                    expect(notFound.isTechnicalError()).to(equal(true))
                }
                
                
                it("generic error") {
                    let notFound = NetworkStatus.genericError
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("ok") {
                    let notFound = NetworkStatus.ok
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("offline error") {
                    let notFound = NetworkStatus.offline
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("host name not found error") {
                    let notFound = NetworkStatus.hostNameNotFound
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("could not connect error") {
                    let notFound = NetworkStatus.couldNotConnectToServer
                    expect(notFound.isTechnicalError()).to(equal(true))
                }

                it("server error") {
                    let notFound = NetworkStatus.serverError
                    expect(notFound.isTechnicalError()).to(equal(true))
                }
               
            }
            
            context("error messages") {
                it("ok") {
                    let ok = NetworkStatus.ok
                    expect(ok.message()).to(equal("Ok"))
                }
                
                it("offline") {
                    let offline = NetworkStatus.offline
                    expect(offline.message()).to(equal("Connection appears to be offline."))
                }
                it("HostNameNotFound") {
                    let hostNotFound = NetworkStatus.hostNameNotFound
                    expect(hostNotFound.message()).to(equal("There was a technical problem."))
                }
                
                it("Timeout") {
                    let coundlNotConnect = NetworkStatus.couldNotConnectToServer
                    expect(coundlNotConnect.message()).to(equal("There was a technical problem."))
                }
                
                it("NotFound") {
                    let notFound = NetworkStatus.notFound
                    expect(notFound.message()).to(equal("The resource you are looking for doesn't exist."))
                }
                
                it("ServerError") {
                    let serverError = NetworkStatus.serverError
                    expect(serverError.message()).to(equal("There was a technical problem."))
                }
            }
        }
    }
}
