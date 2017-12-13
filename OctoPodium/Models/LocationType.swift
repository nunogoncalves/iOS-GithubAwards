//
//  LocationType.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 01/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

enum LocationType: String {
    
    case world
    case city
    case country

    init(rawValue: String) {

        switch rawValue.lowercased() {
        case "city": self = .city
        case "country": self = .country
        default: self = .world
        }
    }
    
    var hasName: Bool {
        return self != .world
    }
}
