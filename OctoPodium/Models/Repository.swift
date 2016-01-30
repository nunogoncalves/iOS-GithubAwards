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
    let description: String
    
    init(name: String, stars: String, description: String) {
        self.name = name
        self.stars = stars
        self.description = description
    }
    
}
