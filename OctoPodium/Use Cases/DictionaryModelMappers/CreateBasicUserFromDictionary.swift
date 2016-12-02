//
//  CreateUserFromDictionary.swift
//  OctoPodium
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
    fileprivate static func buildUserFrom(_ userDic: NSDictionary) -> User {
        let user = User(login: loginFrom(userDic), avatarUrl: avatarUrlFrom(userDic))
        user.starsCount = (userDic["stars_count"] ?? 0) as? Int
        return user
    }
    
    fileprivate static func loginFrom(_ userDic: NSDictionary) -> String {
        return extractStringValueFor("login", fromDic: userDic)
    }
    
    fileprivate static func avatarUrlFrom(_ userDic: NSDictionary) -> String {
        return extractStringValueFor("gravatar_url", fromDic: userDic)
    }
    
    fileprivate static func extractStringValueFor(_ key: String, fromDic: NSDictionary) -> String {
        return (fromDic[key] ?? "" ) as! String
    }
}
