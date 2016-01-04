//
//  NetworkRequester.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Network {

    class Requester {
        
        var URLSession = NSURLSession.self
        
        let networkResponseHandler: Data.HandleResponse
        
        init(networkResponseHandler: Data.HandleResponse) {
            self.networkResponseHandler = networkResponseHandler
        }
        
        func makeGet(urlStr: String) {
            let task = buildRequesterTaskFor(urlStr)
            task.resume()
        }
        
        private func buildRequesterTaskFor(urlStr: String) -> NSURLSessionDataTask {
            let url = NSURL(string: urlStr.urlEncoded())
            //http://stackoverflow.com/questions/24016142/how-to-make-an-http-request-in-swift
            return URLSession.sharedSession().dataTaskWithURL(url!, completionHandler: completionHandler)
        }
        
        private func completionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
            
            if let error = error {
                if error.code == NetworkStatus.Offline.rawValue {
                    return handleFailure(.Offline)
                } else {
                    if error.code == NetworkStatus.HostNameNotFound.rawValue {
                        return handleFailure(.HostNameNotFound)
                    }
                    if error.code == NetworkStatus.CouldNotConnectToServer.rawValue {
                        return handleFailure(.CouldNotConnectToServer)
                    }
                    return handleFailure(.GenericError)
                }
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                return handleFailure(.GenericError)
            }
            
            if response.statusCode == 200 {
                return handleSuccess(data)
            } else {
                if response.statusCode == 404 {
                    return handleFailure(.NotFound)
                } else if response.statusCode == 500 {
                    return handleFailure(.ServerError)
                } else {
                    return handleFailure(.GenericError)
                }
                
            }
        }
        
        private func handleSuccess(data: NSData?) {
            do {
                let data = try convertDataToDictionary(data!)
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
