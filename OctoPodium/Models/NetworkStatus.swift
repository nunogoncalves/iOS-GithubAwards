//
//  NetworkStatus.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

enum NetworkStatus: Int {
    case ok = 200
    case created = 201
    case noContent = 204
    case timeout = -1001
    case offline = -1009
    case hostNameNotFound = -1003 //github-awardsboooo.com
    case couldNotConnectToServer = -1004 //ex: localhost turned off
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    case genericError = -1
    
    func success() -> Bool {
        let codes: [NetworkStatus] = [.ok, .created, .noContent]
        return codes.contains(self)
    }
    
    func message() -> String {
        let technicalErrorMessage = "There was a technical problem."
        switch self {
        case ok:
            return "Ok"
        case created:
            return "Created"
        case noContent:
            return "No Content"
        case timeout:
            return "Request exceded wait time."
        case offline:
            return "Connection appears to be offline."
        case notFound:
            return "The resource you are looking for doesn't exist."
        case unauthorized:
            return "Unauthorized request."
        case hostNameNotFound, couldNotConnectToServer, serverError:
            return technicalErrorMessage
        default:
            return technicalErrorMessage
        }
    }
    
    func isTechnicalError() -> Bool {
        let nonTechErrors: [NetworkStatus] = [.unauthorized, .notFound]
        return !nonTechErrors.contains(self)
    }
}
