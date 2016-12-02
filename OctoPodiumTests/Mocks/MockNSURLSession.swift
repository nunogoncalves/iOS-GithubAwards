//
//  NSURLSession.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class MockNSURLSession: URLSession {
    
    typealias Response = (data: Foundation.Data?, urlResponse: URLResponse?, error: Error?)
    typealias CompletionHandler = ((Foundation.Data?, URLResponse?, Error?) -> Void)
    
    var completionHandler: CompletionHandler?
    
    static var mockResponse: (data: Foundation.Data?, urlResponse: URLResponse?, error: Error?) = (data: nil, urlResponse: nil, error: nil)
    
    override var shared: MockNSURLSession {
        return MockNSURLSession()
    }
    
    override func dataTaskWithURL(url: URL, completionHandler: @escaping @escaping CompletionHandler) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return MockTask(response: MockNSURLSession.mockResponse, completionHandler: completionHandler)
    }
    
    class MockTask: URLSessionDataTask {
        var mockResponse: Response
        let completionHandler: CompletionHandler?
        
        init(response: Response, completionHandler: ((Foundation.Data!, URLResponse!, Error!) -> Void)?) {
            mockResponse = response
            self.completionHandler = completionHandler
        }
        override func resume() {
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }
}
