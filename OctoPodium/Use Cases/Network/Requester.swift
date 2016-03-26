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
        
        func makeGet(urlStr: String, headerParameters: [String : String]?) {
            let task = buildRequesterTaskFor(urlStr,
                                             httpMethod: "GET",
                                             headerParameters: headerParameters,
                                             bodyParameters: nil)
            task.resume()
        }
        
        func makePost(urlStr: String,
                      headerParameters: [String : String],
                      bodyParameters: [String : AnyObject]) {
            let task = buildRequesterTaskFor(urlStr,
                                             httpMethod: "POST",
                                             headerParameters: headerParameters,
                                             bodyParameters: bodyParameters)
            task.resume()
        }
        
        private func buildRequesterTaskFor(
                urlStr: String,
                httpMethod: String,
                headerParameters: [String : String]?,
                bodyParameters: NSDictionary?) -> NSURLSessionDataTask {
            let url = NSURL(string: urlStr.urlEncoded())
            let session = URLSession.init(configuration: sessionConfBuilder.sessionConfiguration())
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = httpMethod
            
            if let parameters = bodyParameters {
                let postData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
                request.HTTPBody = postData
            }
            
            if let headerParams = headerParameters {
                for (header, value) in headerParams {
                    request.addValue(value, forHTTPHeaderField: header)
                }
            }
            request.setValue("ios", forHTTPHeaderField: "client-os")
            return session.dataTaskWithRequest(request, completionHandler: completionHandler)
        }
        
        private func completionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
            var responseData: NSDictionary?
            do {
                if let d = data {
                    responseData = try convertDataToDictionary(d)
                }
            } catch _ {
                handleFailure(.GenericError, responseDictionary: nil)
            }
                
            let statusVerifier = VerifyRequestStatus(response: response, error: error, responseDictionary: responseData)
            
            if statusVerifier.success() {
                handleSuccess(data)
            } else {
                handleFailure(statusVerifier.status(), responseDictionary: responseData)
            }
        }
        
        private func handleSuccess(data: NSData?) {
            guard let data = data else { return handleFailure(.GenericError, responseDictionary: nil) }
            do {
                let data = try convertDataToDictionary(data)
                networkResponseHandler.success(data)
            } catch _ {
                handleFailure(.GenericError, responseDictionary: nil)
            }
        }
        
        private func handleFailure(status: NetworkStatus, responseDictionary: NSDictionary?) {
            networkResponseHandler.failure(ApiResponse(status: status, responseDictionary: responseDictionary))
        }
        
        private func convertDataToDictionary(data: NSData) throws -> NSDictionary {
            let dictionary = try NSJSONSerialization
                    .JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            
            if dictionary is NSDictionary {
                return dictionary as! NSDictionary
            } else if dictionary is NSArray {
                return ["response" : (dictionary as! NSArray)]
            }
            
            throw JSONParseError.NoDicNorArray
        }
    }
}

enum JSONParseError : ErrorType {
    case NoDicNorArray
}
