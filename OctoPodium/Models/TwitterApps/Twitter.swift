//
//  TwitterApp.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Twitter: TwitterAppProtocol {

    let scheme = "twitter://"
    func postURL(message: String) -> URL {
        return URL(string: "\(scheme)post?message=\(message)")!
    }
}
