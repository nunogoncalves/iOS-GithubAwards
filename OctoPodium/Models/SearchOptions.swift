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
        return "\(buildLanguage())\(buildLocation())\(buildType())\(buildPage())"
    }
    
    private func buildLanguage() -> String {
        let lang = language.lowercased()
        return "language=\(lang)"
    }
    
    private func buildLocation() -> String {
        let type = getRealType()
        if type == "world" { return "" }
        return "&\(type)=\(location.lowercased())"
    }
    
    private func buildType() -> String {
        return "&type=\(getRealType())"
    }
    
    private func buildPage() -> String {
        if page > 0 {
            return "&page=\(page)"
        }
        return ""
    }
    
    private func getRealType() -> String {
        return locationType.rawValue
    }
}
