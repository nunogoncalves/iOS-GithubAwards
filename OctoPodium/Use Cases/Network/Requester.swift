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
        
        let URLSession: Foundation.URLSession.Type
        private let networkResponseHandler: Data.ResponseHandler
        private let sessionConfBuilder = SessionConfigurationBuilder()
        
        private let session: Foundation.URLSession
        
        init(networkResponseHandler: Data.ResponseHandler, urlSession: Foundation.URLSession.Type = Foundation.URLSession.self) {
            self.networkResponseHandler = networkResponseHandler
            self.URLSession = urlSession
            session = urlSession.init(configuration: sessionConfBuilder.sessionConfiguration())
        }
        
        func call(
            _ url: URL,
            httpMethod method: HTTPMethod,
            headers: HeadParams?,
            bodyParams: BodyParams?
        ) {
                    
            let task = buildRequesterTask(
                with: url,
                httpMethod: method,
                headers: headers,
                bodyParameters: bodyParams
            )
            task.resume()
        }
        
        private func buildRequesterTask(
            with url: URL,
            httpMethod: HTTPMethod,
            headers: HeadParams?,
            bodyParameters: BodyParams?
        ) -> URLSessionDataTask {

            let request = NSMutableURLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            
            addIfNecessary(bodyParameters, to: request)
            addIfNecessary(headers, to: request)

            return session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
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
            var responseJSON: JSON?
            
            doInCatchBlock { [weak self] in
                if data != nil && data!.count > 0 {
                    responseJSON = try self?.convertDataToDictionary(data!)
                }
            }
            
            let statusVerifier = VerifyRequestStatus(response: response, error: error, responseDictionary: responseJSON)
            
            if statusVerifier.success() {
                if statusVerifier.status == .noContent {
                    handleSuccess(try! JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted))
                } else {
                    handleSuccess(data)
                }
            } else {
                handleFailure(statusVerifier.status, responseJSON: responseJSON)
            }
        }
        
        private func handleSuccess(_ data: Foundation.Data?) {
            guard let data = data else { return handleFailure(.genericError, responseJSON: nil) }
            doInCatchBlock { [weak self] in
                let data = try self?.convertDataToDictionary(data)
                self?.networkResponseHandler.success(data!)
            }
        }
        
        private func handleFailure(_ status: NetworkStatus, responseJSON: JSON?) {
            networkResponseHandler.failure(ApiResponse(status: status, json: responseJSON))
        }
        
        private func convertDataToDictionary(_ data: Foundation.Data) throws -> JSON {
            let dictionary = try JSONSerialization
                    .jsonObject(with: data, options: .mutableContainers)
            
            if dictionary is JSON {
                return dictionary as! JSON
            } else if dictionary is NSArray {
                return ["response" : (dictionary as! NSArray)]
            }
            
            throw JSONParseError.noDicNorArray
        }
        
        private func doInCatchBlock(_ action: (() throws -> ())) {
            do {
                try action()
            } catch _ {
                handleFailure(.genericError, responseJSON: nil)
            }
        }
    }
}

enum JSONParseError : Error {
    case noDicNorArray
}
