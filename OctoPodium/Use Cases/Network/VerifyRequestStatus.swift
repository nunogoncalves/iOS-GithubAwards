//
//  WasRequestASuccess.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

class VerifyRequestStatus {
    
    let response: URLResponse?
    var responseDictionary: NSDictionary?
    let error: Error?
    
    private let errorCodes = [
        NetworkStatus.offline.rawValue,
        NetworkStatus.unauthorized.rawValue,
        NetworkStatus.timeout.rawValue,
        NetworkStatus.hostNameNotFound.rawValue,
        NetworkStatus.couldNotConnectToServer.rawValue,
    ]
    
    private let successCodes = [
        NetworkStatus.ok.rawValue,
        NetworkStatus.created.rawValue,
        NetworkStatus.noContent.rawValue
    ]
    
    private let responseCodes = [
        NetworkStatus.ok.rawValue,
        NetworkStatus.created.rawValue,
        NetworkStatus.noContent.rawValue,
        NetworkStatus.unauthorized.rawValue,
        NetworkStatus.notFound.rawValue,
        NetworkStatus.serverError.rawValue,
    ]
    
    init(response: URLResponse?, error: Error?, responseDictionary: NSDictionary?) {
        self.response = response
        self.responseDictionary = responseDictionary
        self.error = error
    }
    
    func success() -> Bool {
        if let response = response as? HTTPURLResponse {
            return successCodes.contains(response.statusCode)
        }
        return false
    }
    
    func apiResponse() -> ApiResponse {
        return ApiResponse(status: status(), responseDictionary: responseDictionary)
    }
    
    func status() -> NetworkStatus {
        if error != nil {
            return checkStatusFrom(error!)
        }
        
        if ((response as? HTTPURLResponse) != nil) {
            return checkStatusFrom(response as! HTTPURLResponse)
        }
        
        return .genericError
    }
    
    private func checkStatusFrom(_ error: Error) -> NetworkStatus {
        return checkStatusIn(errorCodes, code: (error as! NSError).code)
    }

    private func checkStatusFrom(_ response: HTTPURLResponse) -> NetworkStatus {
        return checkStatusIn(responseCodes, code: response.statusCode)
    }
    
    private func checkStatusIn(_ codes: [Int], code: Int) -> NetworkStatus {
        if codes.contains(code) {
            return NetworkStatus(rawValue: code)!
        }
        return .genericError
    }
    
}
