//
//  NSURLSession.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class MockNSURLSession: NSURLSession {
    
    typealias Response = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)
    typealias CompletionHandler = ((NSData!, NSURLResponse!, NSError!) -> Void)
    
    var completionHandler: CompletionHandler?
    
    static var mockResponse: (data: NSData?, urlResponse: NSURLResponse?, error: NSError?) = (data: nil, urlResponse: nil, error: nil)
    
    override class func sharedSession() -> MockNSURLSession {
        return MockNSURLSession()
    }
    
    override func dataTaskWithURL(url: NSURL, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        self.completionHandler = completionHandler
        return MockTask(response: MockNSURLSession.mockResponse, completionHandler: completionHandler)
    }
    
    class MockTask: NSURLSessionDataTask {
        var mockResponse: Response
        let completionHandler: CompletionHandler?
        
        init(response: Response, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
            mockResponse = response
            self.completionHandler = completionHandler
        }
        override func resume() {
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }
}
