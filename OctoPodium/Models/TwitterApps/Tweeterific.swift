//
//  Tweeterific.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Tweeterific: TwitterAppProtocol {

    let scheme = "twitterrific://"
    let account: String

    func postURL(message: String) -> URL {
        return URL(string: "twitterrific://\(account)/post?message=\(message)")!
    }
}
