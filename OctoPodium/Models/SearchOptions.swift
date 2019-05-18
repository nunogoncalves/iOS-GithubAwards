//
//  SearchOptions.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class SearchOptions {
    
    var language: String
    var locationType: LocationType
    
    var page: Int

    init(language: String, locationType: LocationType, page: Int) {
        self.language = language
        self.locationType = locationType
        self.page = page
    }

    var queryItems: [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: "language", value: language.lowercased().urlEncoded()),
            URLQueryItem(name: "type", value: locationType.type),
        ]

        if !locationType.nameOrEmpty.isEmpty {
            queryItems.append(URLQueryItem(name: locationType.type, value: locationType.nameOrEmpty))
        }
        if page > 0 {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }

        return queryItems
    }
}
