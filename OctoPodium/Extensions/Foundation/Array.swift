//
//  Array.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Collection {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try reduce(0) { $0 + (try predicate($1) ? 1 : 0) }
    }

    func any(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try first(where: predicate) != nil
    }
}
