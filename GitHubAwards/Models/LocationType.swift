//
//  LocationType.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 01/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

enum LocationType: String {
    
    case World = "world"
    case City = "city"
    case Country = "country"
    
    static func getTypeFor(rawValue: String) -> LocationType {
        switch rawValue.lowercaseString {
        case "city": return .City
        case "country": return .Country
        default: return .World
        }
    }
    
    func hasName() -> Bool {
        return !(self == .World)
    }
    
}
