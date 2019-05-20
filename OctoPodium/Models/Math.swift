//
//  Math.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 20/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

typealias LinearFunction = ((CGFloat) -> CGFloat)

func linearFunction(for p1: CGPoint, and p2: CGPoint) -> LinearFunction {
    let m = (p2.y - p1.y) / (p2.x - p1.x)
    let b = p2.y - m * p2.x
    return {
        m * $0 + b
    }
}
