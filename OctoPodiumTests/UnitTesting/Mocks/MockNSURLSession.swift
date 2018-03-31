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
    
    var completionHandler: CompletionHandler = { _, _, _ in }

    init(configuration: URLSessionConfiguration) {
        super.init()
    }

    static var mockResponse: (data: Foundation.Data?, urlResponse: URLResponse?, error: Error?) = (data: nil, urlResponse: nil, error: nil)

    //THe failing test fails because this is not being called... something's wrong with this implementation...
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Foundation.Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        self.completionHandler = completionHandler
        return MockTask(response: MockNSURLSession.mockResponse, completionHandler: completionHandler)
    }

    class MockTask: URLSessionDataTask {
        var mockResponse: Response
        let completionHandler: CompletionHandler
        
        init(response: Response, completionHandler: @escaping ((Foundation.Data?, URLResponse?, Error?) -> Void) = { _, _, _ in }) {
            mockResponse = response
            self.completionHandler = completionHandler
        }
        override func resume() {
            completionHandler(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }
}
