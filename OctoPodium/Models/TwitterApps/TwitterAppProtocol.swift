//
//  TwitterAppProtocol.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol TwitterAppProtocol {
    var scheme: String { get }
    func postURL(message: String) -> URL
}

extension TwitterAppProtocol {
    var name: String {
        return String(describing: type(of: self))
    }
}
