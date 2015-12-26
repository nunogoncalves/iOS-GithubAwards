//
//  NetworkRequesterTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 26/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
@testable import GitHubAwards

class NetworkRequesterTests : QuickSpec {
    
    override func spec() {
        let responseHandler = NetworkResponse()
        var requester: NetworkRequester!
        
        beforeEach {
            requester = NetworkRequester(networkResponseHandler: responseHandler)
            requester.URLSession = MockNSURLSession.self
        }
        
        it("calls response success method") {
            var responseStr = ""
            responseHandler.successCallback = { data in
                responseStr = "success"
            }
            
            responseHandler.failureCallback = {
                responseStr = "failure"
            }
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(["meta": ["code": 200], "data": ["username": "dasdom", "name": "Dpminik Hauser", "id": "1472"]], options: NSJSONWritingOptions.PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "\(K.usersBaseUrl)/users")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            
            MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            
            XCTAssertEqual(responseStr, "", "")
            requester.makeGet("")
            XCTAssertEqual(responseStr, "success", "")
        }
        
        it("calls response failure method") {
            var responseStr = ""
            responseHandler.successCallback = { _ in
                responseStr = "success"
            }
            
            responseHandler.failureCallback = {
                responseStr = "failure"
            }
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(["meta": ["code": 200], "data": ["username": "dasdom", "name": "Dpminik Hauser", "id": "1472"]], options: NSJSONWritingOptions.PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "\(K.usersBaseUrl)/users")!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
            
            MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            
            XCTAssertEqual(responseStr, "", "")
            requester.makeGet("")
            XCTAssertEqual(responseStr, "failure", "")
        }
    }
}