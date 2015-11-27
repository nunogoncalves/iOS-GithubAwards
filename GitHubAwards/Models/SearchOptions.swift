//
//  SearchOptions.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class SearchOptions {
    
    var language = "JavaScript"
    var location = "San Francisco"
    var locationType = "worldwide"
    private let locationTypes = ["city", "country", "world"]
    
    var page = 0
    
    func urlEncoded() -> String {
        return "\(buildLanguage())\(buildLocation())\(buildType())\(buildPage())"
    }
    
    private func buildLanguage() -> String {
        let lang = language
        return "language=\(lang)"
    }
    
    private func buildLocation() -> String {
        let type = getRealType()
        if type == "world" { return "" }
        return "&\(type)=\(location)"
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
        return locationTypes.indexOf(locationType) > -1 ? locationType : "world"
    }
}
