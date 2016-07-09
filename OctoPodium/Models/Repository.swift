//
//  Language.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct Repository {
    
    let name: String
    let stars: String
    let language: String?
    let url: String
    let description: String
    let user: String
    
    
    var completeName: String {
        return "\(user)/\(name)"
    }
    
    init(name: String, stars: String, description: String, language: String?) {
        self.name = name.substring(after: "/")!
        self.stars = stars
        self.description = description
        self.language = language
        self.url = "https://github.com/\(name)"
        self.user = Repository.getUserFromName(name)
    }
    
    private static func getUserFromName(_ name: String) -> String {
        return name.substringUntil("/") ?? ""
    }
    
}
