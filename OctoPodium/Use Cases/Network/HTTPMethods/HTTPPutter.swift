//
//  HTTPPutter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol HTTPPutter {
    var httpMethod: HTTPMethod { get }
}

extension HTTPPutter {
    var httpMethod: HTTPMethod {
        return .put
    }
}

