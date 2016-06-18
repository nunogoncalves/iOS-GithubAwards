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
        
        init() {
            if let token = GithubToken.instance.token {
                headers = ["Authorization" : "token \(token)"]
            }
        }
        
        func getDataFrom(_ dictionary: NSDictionary) -> User {
            return User(
                login: dictionary["login"] as? String ?? "",
                avatarUrl: dictionary["avatar_url"] as? String ?? ""
            )
        }
        
        func getUrl() -> String {
            return kUrls.userUrl
        }
        
    }
}
