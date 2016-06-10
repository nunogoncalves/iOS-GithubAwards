//
//  EmptyBody.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol EmptyBody {
    var bodyParams: BodyParams? { get }
}

extension EmptyBody {
    var bodyParams: BodyParams? {
        return nil
    }
}
