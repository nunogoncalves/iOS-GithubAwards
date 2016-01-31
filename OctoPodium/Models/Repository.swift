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
    let description: String
    
    init(name: String, stars: String, description: String, language: String?) {
        self.name = name
        self.stars = stars
        self.description = description
        self.language = language
    }
    
}
