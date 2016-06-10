//
//  Poster.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol HTTPPoster {
    var httpMethod: HTTPMethod { get }
}

extension HTTPPoster {
    var httpMethod: HTTPMethod {
        return .POST
    }
}
