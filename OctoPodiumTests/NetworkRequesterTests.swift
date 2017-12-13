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
            requester = Network.Requester(networkResponseHandler: responseHandler, urlSession: MockNSURLSession.self)
        }
        
        it("calls response success method") {
            var responseStr = ""
            responseHandler.successCallback = { _ in
                responseStr = "success"
            }

            MockNSURLSession(configuration: URLSessionConfiguration.default)

            responseHandler.failureCallback = { apiResponse in
                responseStr = "failure"
            }

            let jsonData = try! JSONSerialization.data(withJSONObject: ["": ""], options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            
            requester.call("https://google.com", httpMethod: .get, headers: nil, bodyParams: nil)
            
            expect(responseStr).toEventually(equal("success")) 
        }
        
//        it("calls response failure method") {
//            var responseStr = ""
//            responseHandler.successCallback = { _ in
//                responseStr = "success"
//            }
//
//            responseHandler.failureCallback = { _ in
//                responseStr = "failure"
//            }
//
//            let jsonData = try! JSONSerialization.data(withJSONObject: ["": ""], options: .prettyPrinted)
//            let urlResponse = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
//
//            MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
//
//            requester.call("https://google.com", httpMethod: .get, headers: nil, bodyParams: nil)
//            expect(responseStr).toEventually(equal("failure"))
//        }
    }
}
