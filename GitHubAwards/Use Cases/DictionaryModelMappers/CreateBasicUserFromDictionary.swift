//
//  CreateUserFromDictionary.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 28/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class CreateBasicUserFromDictionary {
    
    let user: User
    
    let userDic: NSDictionary
    
    init(userDic: NSDictionary) {
        self.userDic = userDic
        user = CreateBasicUserFromDictionary.buildUserFrom(userDic)
    }
    
}

extension CreateBasicUserFromDictionary {
    private static func buildUserFrom(userDic: NSDictionary) -> User {
        let user = User(login: loginFrom(userDic), avatarUrl: avatarUrlFrom(userDic))
        user.starsCount = (userDic["stars_count"] ?? 0) as? Int
        return user
    }
    
    private static func loginFrom(userDic: NSDictionary) -> String {
        return extractStringValueFor("login", fromDic: userDic)
    }
    
    private static func avatarUrlFrom(userDic: NSDictionary) -> String {
        return extractStringValueFor("gravatar_url", fromDic: userDic)
    }
    
    private static func extractStringValueFor(key: String, fromDic: NSDictionary) -> String {
        return (fromDic[key] ?? "" ) as! String
    }
}
