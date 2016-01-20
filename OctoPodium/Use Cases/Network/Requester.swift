//
//  NetworkRequester.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Network {

    class Requester {
        
        var URLSession = NSURLSession.self
        private let networkResponseHandler: Data.ResponseHandler
        private let sessionConfBuilder = SessionConfigurationBuilder()
        
        init(networkResponseHandler: Data.ResponseHandler) {
            self.networkResponseHandler = networkResponseHandler
        }
        
        func makeGet(urlStr: String) {
            let task = buildRequesterTaskFor(urlStr)
            task.resume()
        }
        
        private func buildRequesterTaskFor(urlStr: String) -> NSURLSessionDataTask {
            let url = NSURL(string: urlStr.urlEncoded())
            let session = URLSession.init(configuration: sessionConfBuilder.sessionConfiguration())
            let request = NSMutableURLRequest(URL: url!)
            request.setValue("ios", forHTTPHeaderField: "client-os")
            return session.dataTaskWithRequest(request, completionHandler: completionHandler)
        }
        
        private func completionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
            let statusVerifier = VerifyRequestStatus(response: response, error: error)
            
            if statusVerifier.success() {
                handleSuccess(data)
            } else {
                handleFailure(statusVerifier.status())
            }
        }
        
        private func handleSuccess(data: NSData?) {
            guard let data = data else { return handleFailure(.GenericError) }
            do {
                let data = try convertDataToDictionary(data)
                networkResponseHandler.success(data)
            } catch _ {
                handleFailure(.GenericError)
            }
        }
        
        private func handleFailure(status: NetworkStatus) {
            networkResponseHandler.failure(status)
        }
        
        private func convertDataToDictionary(data: NSData) throws -> NSDictionary {
            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        }
    }
}
