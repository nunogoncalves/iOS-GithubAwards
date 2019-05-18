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
        
        var url: URL {
            return URL(string: "\(kUrls.usersBaseUrl)/\(self.login)".urlEncoded())!
        }
        
        func parse(_ json: JSON) -> User {
            
            return CreateFullUserFromDictionary(from: json["user"] as! JSON).user
        }
    }
}
