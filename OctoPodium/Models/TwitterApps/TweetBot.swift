//
//  TweetBot.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct TweetBot: TwitterAppProtocol {

    let scheme = "tweetbot://"
    let account: String

    func postURL(message: String) -> URL {
        return URL(string: "\(scheme)\(account)/post?text=\(message)")!
    }
}
