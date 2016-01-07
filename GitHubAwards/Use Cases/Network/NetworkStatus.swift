//
//  NetworkStatus.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 04/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

enum NetworkStatus: Int {
    case Ok = 200
    case Offline = -1009 //desligar a net
    case HostNameNotFound = -1003 //github-awardsboooo.com
    case CouldNotConnectToServer = -1004 //ex: localhost turned off
    case NotFound = 404
    case ServerError = 500
    case GenericError = -1
    
    func message() -> String {
        let technicalErrorMessage = "There was a technical problem."
        switch self {
        case Ok:
            return "Ok"
        case Offline:
            return "Connection appears to be offline."
        case HostNameNotFound:
            return technicalErrorMessage
        case CouldNotConnectToServer:
            return technicalErrorMessage
        case NotFound:
            return "The resource you are looking for doesn't exist."
        case ServerError:
            return technicalErrorMessage
        default:
            return technicalErrorMessage
        }
    }
    
    func isTechnicalError() -> Bool {
        return self == .NotFound ? false : true
    }
}
