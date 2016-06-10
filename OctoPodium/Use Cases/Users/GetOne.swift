//
//  SearchUser.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 28/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Users {
    class GetOne: Requestable, Parameterless, HTTPGetter {
        
        private let login: String
        
        init(login: String) {
            self.login = login
        }
        
        func getUrl() -> String {
            return "\(kUrls.usersBaseUrl)/\(self.login)"
        }
        
        func getDataFrom(dictionary: NSDictionary) -> User {
            return CreateFullUserFromDictionary(userDic: dictionary["user"]! as! NSDictionary).user
        }
    }
}