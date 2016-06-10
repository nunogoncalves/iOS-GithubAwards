//
//  HTTPDeleter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol HTTPDeleter {
    var httpMethod: HTTPMethod { get }
}

extension HTTPDeleter {
    var httpMethod: HTTPMethod {
        return .DELETE
    }
}
