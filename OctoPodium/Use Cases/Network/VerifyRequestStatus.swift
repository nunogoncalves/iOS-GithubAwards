//
//  WasRequestASuccess.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

class VerifyRequestStatus {
    
    let response: NSURLResponse?
    var responseDictionary: NSDictionary?
    let error: NSError?
    
    private let errorCodes = [
        NetworkStatus.Offline.rawValue,
        NetworkStatus.Unauthorized.rawValue,
        NetworkStatus.Timeout.rawValue,
        NetworkStatus.HostNameNotFound.rawValue,
        NetworkStatus.CouldNotConnectToServer.rawValue,
    ]
    
    private let successCodes = [
        NetworkStatus.Ok.rawValue,
        NetworkStatus.Created.rawValue,
        NetworkStatus.NoContent.rawValue
    ]
    
    private let responseCodes = [
        NetworkStatus.Ok.rawValue,
        NetworkStatus.Created.rawValue,
        NetworkStatus.NoContent.rawValue,
        NetworkStatus.Unauthorized.rawValue,
        NetworkStatus.NotFound.rawValue,
        NetworkStatus.ServerError.rawValue,
    ]
    
    init(response: NSURLResponse?, error: NSError?, responseDictionary: NSDictionary?) {
        self.response = response
        self.responseDictionary = responseDictionary
        self.error = error
    }
    
    func success() -> Bool {
        if let response = response as? NSHTTPURLResponse {
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
        
        if ((response as? NSHTTPURLResponse) != nil) {
            return checkStatusFrom(response as! NSHTTPURLResponse)
        }
        
        return .GenericError
    }
    
    private func checkStatusFrom(error: NSError) -> NetworkStatus {
        return checkStatusIn(errorCodes, code: error.code)
    }

    private func checkStatusFrom(response: NSHTTPURLResponse) -> NetworkStatus {
        return checkStatusIn(responseCodes, code: response.statusCode)
    }
    
    private func checkStatusIn(codes: [Int], code: Int) -> NetworkStatus {
        if codes.contains(code) {
            return NetworkStatus(rawValue: code)!
        }
        return .GenericError
    }
    
}