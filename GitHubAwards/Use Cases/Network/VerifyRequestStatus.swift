//
//  WasRequestASuccess.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

class VerifyRequestStatus {
    
    let response: NSURLResponse?
    let error: NSError?
    
    private let errorCodes = [
        NetworkStatus.Offline.rawValue,
        NetworkStatus.HostNameNotFound.rawValue,
        NetworkStatus.CouldNotConnectToServer.rawValue,
    ]
    
    private let responseCodes = [
        NetworkStatus.Ok.rawValue,
        NetworkStatus.NotFound.rawValue,
        NetworkStatus.ServerError.rawValue,
    ]
    
    init(response: NSURLResponse?, error: NSError?) {
        self.response = response
        self.error = error
    }
    
    func success() -> Bool {
        if let response = response as? NSHTTPURLResponse {
            return response.statusCode == 200
        }
        return false
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