//
//  Getter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol HTTPGetter {
    
    var httpMethod: HTTPMethod { get }
}

extension HTTPGetter {

    var httpMethod: HTTPMethod {
        return .get
    }
}
