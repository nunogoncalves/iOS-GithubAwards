//
//  GetUsers.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Users {
    class GetList: Getter {
        
        private let searchOptions: SearchOptions
        
        init(searchOptions: SearchOptions) {
            self.searchOptions = searchOptions
        }
        
        func getUrl() -> String {
            return "\(kUrls.usersBaseUrl)/?\(searchOptions.urlEncoded())"
        }
        
        func getDataFrom(dictionary: NSDictionary) -> UsersListResponse {
            let paginator = Paginator(dictionary: dictionary)
            let users = ConvertUsersDictionaryToUsers(data: dictionary).users
            let usersResponse = UsersListResponse(users: users, paginator: paginator)
            return usersResponse
        }
    }
}
