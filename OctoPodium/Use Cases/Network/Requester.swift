//
//  NetworkRequester.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

typealias BodyParams = [String : AnyObject]
typealias HeadParams = [String : String]

struct Network {

    class Requester {
        
        var URLSession = NSURLSession.self
        private let networkResponseHandler: Data.ResponseHandler
        private let sessionConfBuilder = SessionConfigurationBuilder()
        
        private let session: NSURLSession
        
        init(networkResponseHandler: Data.ResponseHandler) {
            self.networkResponseHandler = networkResponseHandler
            session = URLSession.init(configuration: sessionConfBuilder.sessionConfiguration())
        }
        
        func call(urlStr: String,
                  httpMethod method: HTTPMethod,
                  headers: HeadParams?,
                  bodyParams: BodyParams?) {
                    
            let task = buildRequesterTaskFor(urlStr,
                    httpMethod: method,
                    headers: headers,
                    bodyParameters: bodyParams)
            task.resume()
        }
        
        private func buildRequesterTaskFor(urlStr: String,
                                           httpMethod: HTTPMethod,
                                           headers: HeadParams?,
                                           bodyParameters: BodyParams?) -> NSURLSessionDataTask {
                                            
            let request = buildURLRequestFor(urlStr)
            request.HTTPMethod = httpMethod.rawValue
            
            addIfNecessary(bodyParameters, to: request)
            addIfNecessary(headers, to: request)
                                
            return session.dataTaskWithRequest(request, completionHandler: completionHandler)
        }
        
        private func buildURLRequestFor(url: String) -> NSMutableURLRequest {
            let url = NSURL(string: url.urlEncoded())
            let request = NSMutableURLRequest(URL: url!)
            return request
        }
        
        private func addIfNecessary(bodyParameters: BodyParams?, to request: NSMutableURLRequest) {
            if let parameters = bodyParameters {
                let postData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
                request.HTTPBody = postData
            }
        }
        
        private func addIfNecessary(headers: HeadParams?, to request: NSMutableURLRequest) {
            let headerParams = headers ?? ["CLIENT_OS" : "iOS"]
            for (header, value) in headerParams {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        private func completionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
            var responseData: NSDictionary?
            
            doInCatchBlock { [weak self] in
                if data != nil && data!.length > 0 {
                    responseData = try self?.convertDataToDictionary(data!)
                }
            }
            
            let statusVerifier = VerifyRequestStatus(response: response, error: error, responseDictionary: responseData)
            
            if statusVerifier.success() {
                if statusVerifier.status() == .NoContent {
                    handleSuccess(try! NSJSONSerialization.dataWithJSONObject([:], options: .PrettyPrinted))
                } else {
                    handleSuccess(data)
                }
            } else {
                handleFailure(statusVerifier.status(), responseDictionary: responseData)
            }
        }
        
        private func handleSuccess(data: NSData?) {
            guard let data = data else { return handleFailure(.GenericError, responseDictionary: nil) }
            doInCatchBlock { [weak self] in
                let data = try self?.convertDataToDictionary(data)
                self?.networkResponseHandler.success(data!)
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
        
        private func doInCatchBlock(action: (() throws -> ())) {
            do {
                try action()
            } catch _ {
                handleFailure(.GenericError, responseDictionary: nil)
            }
        }
    }
}

enum JSONParseError : ErrorType {
    case NoDicNorArray
}
