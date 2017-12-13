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
        
        var url: String {
            return "\(kUrls.usersBaseUrl)/\(self.login)"
        }
        
        func parse(_ json: JSON) -> User {
            
            return CreateFullUserFromDictionary(from: json["user"] as! JSON).user
        }
    }
}
