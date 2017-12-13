//
//  SearchOptions.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class SearchOptions {
    
    var language = "JavaScript"
    var location = "San Francisco"
    var locationType = LocationType.world
    
    var page = 1
    
    func urlParams() -> String {

        return "\(languageParam)\(locationParam)\(typeParam)\(pageParam)"
    }
    
    private var languageParam: String {

        let lang = language.lowercased()
        return "language=\(lang)"
    }
    
    private var locationParam: String {

        let type = locationType.rawValue
        if type == "world" { return "" }
        return "&\(type)=\(location.lowercased())"
    }
    
    private var typeParam: String {

        return "&type=\(locationType.rawValue)"
    }
    
    private var pageParam: String {

        return page > 0 ? "&page=\(page)" : ""
    }
}
