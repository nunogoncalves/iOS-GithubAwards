//
//  NetworkStatus.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

enum NetworkStatus: Int {
    case Ok = 200
    case Created = 201
    case Timeout = -1001
    case Offline = -1009
    case HostNameNotFound = -1003 //github-awardsboooo.com
    case CouldNotConnectToServer = -1004 //ex: localhost turned off
    case Unauthorized = 401
    case NotFound = 404
    case ServerError = 500
    case GenericError = -1
    
    func success() -> Bool {
        let codes: [NetworkStatus] = [.Ok, .Created]
        return codes.contains(self)
    }
    
    func message() -> String {
        let technicalErrorMessage = "There was a technical problem."
        switch self {
        case Ok:
            return "Ok"
        case Created:
            return "Created"
        case Timeout:
            return "Request exceded wait time."
        case Offline:
            return "Connection appears to be offline."
        case NotFound:
            return "The resource you are looking for doesn't exist."
        case Unauthorized:
            return "Unauthorized request."
        case HostNameNotFound, CouldNotConnectToServer, ServerError:
            return technicalErrorMessage
        default:
            return technicalErrorMessage
        }
    }
    
    func isTechnicalError() -> Bool {
        let nonTechErrors: [NetworkStatus] = [.Unauthorized, .NotFound]
        return !nonTechErrors.contains(self)
    }
}
