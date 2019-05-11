//
//  Medals.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Medals: OptionSet {

    let rawValue: Int

    static let gold = Medals(rawValue: 1 << 0)
    static let silver = Medals(rawValue: 1 << 1)
    static let bronze = Medals(rawValue: 1 << 2)

    static let all: Medals = [.gold, .silver, .bronze]
}
