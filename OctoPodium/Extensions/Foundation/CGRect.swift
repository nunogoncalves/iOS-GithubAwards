//
//  CGRect.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 21/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension CGSize: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Float) {
        self.init(width: CGFloat(value), height: CGFloat(value))
    }
}

extension CGRect: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: Float) {
        self.init(origin: .zero, size: CGSize(width: CGFloat(value), height: CGFloat(value)))
    }
}
