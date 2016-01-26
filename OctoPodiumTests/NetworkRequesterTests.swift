//
//  NetworkRequesterTests.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Quick
import Nimble
@testable import OctoPodium

class NetworkRequesterTests : QuickSpec {
    
    override func spec() {
        let responseHandler = Data.ResponseHandler()
        var requester: Network.Requester!
        
        beforeEach {
            requester = Network.Requester(networkResponseHandler: responseHandler)
            requester.URLSession = MockNSURLSession.self
        }
        
        it("calls response success method") {
            var responseStr = ""
            responseHandler.successCallback = { _ in
                responseStr = "success"
            }
            
            responseHandler.failureCallback = { _ in
                responseStr = "failure"
            }
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(["": ""], options: NSJSONWritingOptions.PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            
            MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            
            XCTAssertEqual(responseStr, "", "")
            requester.makeGet("")
//            XCTAssertEqual(responseStr, "success", "")
        }
        
        it("calls response failure method") {
            var responseStr = ""
            responseHandler.successCallback = { _ in
                responseStr = "success"
            }
            
            responseHandler.failureCallback = { _ in
                responseStr = "failure"
            }
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(["": ""], options: NSJSONWritingOptions.PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "")!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
            
            MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            
            XCTAssertEqual(responseStr, "", "")
            requester.makeGet("")
//            XCTAssertEqual(responseStr, "failure", "")
        }
    }
}