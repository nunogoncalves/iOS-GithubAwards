//
//  UserInfoGetter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    struct UserInfoGetter : Requestable, EmptyBody, HTTPGetter {
        
        var headers: HeadParams?

        let url = kUrls.userUrl

        init() {
            if let token = GithubToken.instance.token {
                headers = ["Authorization" : "token \(token)"]
            }
        }

        func parse(_ json: JSON) -> User {
            return User(from: json, avatarKey: "avatar_url")
        }
    }
}
