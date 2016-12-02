//
//  NetworkRequester.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

typealias BodyParams = [String : Any]
typealias HeadParams = [String : String]

struct Network {

    class Requester {
        
        var URLSession = Foundation.URLSession.self
        private let networkResponseHandler: Data.ResponseHandler
        private let sessionConfBuilder = SessionConfigurationBuilder()
        
        private let session: Foundation.URLSession
        
        init(networkResponseHandler: Data.ResponseHandler) {
            self.networkResponseHandler = networkResponseHandler
            session = URLSession.init(configuration: sessionConfBuilder.sessionConfiguration())
        }
        
        func call(_ urlStr: String,
                  httpMethod method: HTTPMethod,
                  headers: HeadParams?,
                  bodyParams: BodyParams?) {
                    
            let task = buildRequesterTaskFor(urlStr,
                    httpMethod: method,
                    headers: headers,
                    bodyParameters: bodyParams)
            task.resume()
        }
        
        private func buildRequesterTaskFor(_ urlStr: String,
                                           httpMethod: HTTPMethod,
                                           headers: HeadParams?,
                                           bodyParameters: BodyParams?) -> URLSessionDataTask {
                                            
            let request = buildURLRequestFor(urlStr)
            request.httpMethod = httpMethod.rawValue
            
            addIfNecessary(bodyParameters, to: request)
            addIfNecessary(headers, to: request)

            return session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
//            return session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        }
        
        private func buildURLRequestFor(_ url: String) -> NSMutableURLRequest {
            let url = URL(string: url.urlEncoded())
            let request = NSMutableURLRequest(url: url!)
            return request
        }
        
        private func addIfNecessary(_ bodyParameters: BodyParams?, to request: NSMutableURLRequest) {
            if let parameters = bodyParameters {
                let postData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = postData
            }
        }
        
        private func addIfNecessary(_ headers: HeadParams?, to request: NSMutableURLRequest) {
            let headerParams = headers ?? ["CLIENT_OS" : "iOS"]
            for (header, value) in headerParams {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        private func completionHandler(_ data: Foundation.Data?, response: URLResponse?, error: Error?) {
            var responseData: NSDictionary?
            
            doInCatchBlock { [weak self] in
                if data != nil && data!.count > 0 {
                    responseData = try self?.convertDataToDictionary(data!)
                }
            }
            
            let statusVerifier = VerifyRequestStatus(response: response, error: error, responseDictionary: responseData)
            
            if statusVerifier.success() {
                if statusVerifier.status() == .noContent {
                    handleSuccess(try! JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted))
                } else {
                    handleSuccess(data)
                }
            } else {
                handleFailure(statusVerifier.status(), responseDictionary: responseData)
            }
        }
        
        private func handleSuccess(_ data: Foundation.Data?) {
            guard let data = data else { return handleFailure(.genericError, responseDictionary: nil) }
            doInCatchBlock { [weak self] in
                let data = try self?.convertDataToDictionary(data)
                self?.networkResponseHandler.success(data!)
            }
        }
        
        private func handleFailure(_ status: NetworkStatus, responseDictionary: NSDictionary?) {
            networkResponseHandler.failure(ApiResponse(status: status, responseDictionary: responseDictionary))
        }
        
        private func convertDataToDictionary(_ data: Foundation.Data) throws -> NSDictionary {
            let dictionary = try JSONSerialization
                    .jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            if dictionary is NSDictionary {
                return dictionary as! NSDictionary
            } else if dictionary is NSArray {
                return ["response" : (dictionary as! NSArray)]
            }
            
            throw JSONParseError.noDicNorArray
        }
        
        private func doInCatchBlock(_ action: (() throws -> ())) {
            do {
                try action()
            } catch _ {
                handleFailure(.genericError, responseDictionary: nil)
            }
        }
    }
}

enum JSONParseError : Error {
    case noDicNorArray
}
