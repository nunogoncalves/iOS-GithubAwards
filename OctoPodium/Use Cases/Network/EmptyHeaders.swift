//
//  EmptyHeaders.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol EmptyHeaders {
    var headers: HeadParams? { get }
}

extension EmptyHeaders {
    var headers: HeadParams? {
        return nil
    }
}