//
//  LocationType.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 01/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

enum LocationType {
    
    case world
    case country(name: String)
    case city(name: String)

    var hasName: Bool {
        switch self {
        case .world: return false
        case .country, .city: return true
        }
    }

    var nameOrEmpty: String {
        switch self {
        case .world: return ""
        case let .country(name), let .city(name): return name
        }
    }

    var type: String {
        switch self {
        case .world: return "world"
        case .city: return "city"
        case .country: return "country"
        }
    }

    func with(name: String) -> LocationType {
        switch self {
        case .city: return .city(name: name)
        case .country: return .country(name: name)
        case .world: return .world
        }
    }
}
