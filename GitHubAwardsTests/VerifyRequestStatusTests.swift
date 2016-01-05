//
//  VerifyRequestStatusTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
import XCTest
@testable import GitHubAwards

class VerifyRequestStatusTests : QuickSpec {
    
    class NSURLResponseMock : NSHTTPURLResponse {
        
    }
    
    class NSErrorMock: NSError {
    }
    
    override func spec() {
        describe("VerifyRequestStatus") {
            
            context("check for success") {
                
                it("Ok expects true") {
                    let response = NSURLResponseMock(URL: NSURL(), statusCode: NetworkStatus.Ok.rawValue, HTTPVersion: nil, headerFields: nil)
                    let verifier = VerifyRequestStatus(response: response, error: nil)
                    expect(verifier.success()).to(equal(true))
                }
                
                it("offline expects false") {
                    let error = NSErrorMock(domain: "", code: NetworkStatus.Offline.rawValue, userInfo: nil)
                    let verifier = VerifyRequestStatus(response: nil, error: error)
                    expect(verifier.success()).to(equal(false))
                }
                
                it("Host name not found expects false") {
                    let error = NSErrorMock(domain: "", code: NetworkStatus.HostNameNotFound.rawValue, userInfo: nil)
                    let verifier = VerifyRequestStatus(response: nil, error: error)
                    expect(verifier.success()).to(equal(false))
                }
                
                it("could not connect to server expects false") {
                    let error = NSErrorMock(domain: "", code: NetworkStatus.CouldNotConnectToServer.rawValue, userInfo: nil)
                    let verifier = VerifyRequestStatus(response: nil, error: error)
                    expect(verifier.success()).to(equal(false))
                }
            
                it("not found expects false") {
                    let response = NSURLResponseMock(URL: NSURL(), statusCode: NetworkStatus.NotFound.rawValue, HTTPVersion: nil, headerFields: nil)
                    let verifier = VerifyRequestStatus(response: response, error: nil)
                    expect(verifier.success()).to(equal(false))
                }
            
                it("Server Error status expects false") {
                    let response = NSURLResponseMock(URL: NSURL(), statusCode: NetworkStatus.ServerError.rawValue, HTTPVersion: nil, headerFields: nil)
                    let verifier = VerifyRequestStatus(response: response, error: nil)
                    expect(verifier.success()).to(equal(false))
                }
            }
            
            context("error statuses") {
                it("expects an offline status") {
                    let error = NSErrorMock(domain: "", code: NetworkStatus.Offline.rawValue, userInfo: nil)
                    let verifier = VerifyRequestStatus(response: nil, error: error)
                    expect(verifier.status()).to(equal(NetworkStatus.Offline))
                }
                
                it("expects a host name not found status") {
                    let error = NSErrorMock(domain: "", code: NetworkStatus.HostNameNotFound.rawValue, userInfo: nil)
                    let verifier = VerifyRequestStatus(response: nil, error: error)
                    expect(verifier.status()).to(equal(NetworkStatus.HostNameNotFound))
                }
                
                it("expects a could not connect to server status") {
                    let error = NSErrorMock(domain: "", code: NetworkStatus.CouldNotConnectToServer.rawValue, userInfo: nil)
                    let verifier = VerifyRequestStatus(response: nil, error: error)
                    expect(verifier.status()).to(equal(NetworkStatus.CouldNotConnectToServer))
                }
            }
            
            context("response error statuses") {
                it("expects Ok status") {
                    let response = NSURLResponseMock(URL: NSURL(), statusCode: NetworkStatus.Ok.rawValue, HTTPVersion: nil, headerFields: nil)
                    let verifier = VerifyRequestStatus(response: response, error: nil)
                    expect(verifier.status()).to(equal(NetworkStatus.Ok))
                }
                
                it("expects Not Found status") {
                    let response = NSURLResponseMock(URL: NSURL(), statusCode: NetworkStatus.NotFound.rawValue, HTTPVersion: nil, headerFields: nil)
                    let verifier = VerifyRequestStatus(response: response, error: nil)
                    expect(verifier.status()).to(equal(NetworkStatus.NotFound))
                }
                
                it("expects Server Error status") {
                    let response = NSURLResponseMock(URL: NSURL(), statusCode: NetworkStatus.ServerError.rawValue, HTTPVersion: nil, headerFields: nil)
                    let verifier = VerifyRequestStatus(response: response, error: nil)
                    expect(verifier.status()).to(equal(NetworkStatus.ServerError))
                }
            }
        }
    }
}

