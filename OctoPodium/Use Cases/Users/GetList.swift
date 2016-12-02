//
//  GetUsers.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Users {
    class GetList: Requestable, Parameterless, HTTPGetter {
        
        private let searchOptions: SearchOptions
        
        init(searchOptions: SearchOptions) {
            self.searchOptions = searchOptions
        }
        
        func getUrl() -> String {
            var str = "\(kUrls.usersBaseUrl)/?\(searchOptions.urlParams())"
            str = str.replacingOccurrences(of: "+", with: "%2B")
            return str
        }
        
        func getDataFrom(_ dictionary: NSDictionary) -> UsersListResponse {
            let paginator = Paginator(dictionary: dictionary)
            let users = ConvertUsersDictionaryToUsers(data: dictionary).users
            let usersResponse = UsersListResponse(users: users, paginator: paginator)
            return usersResponse
        }
    }
}
