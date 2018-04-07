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
        
        var url: String {
            
            var str = "\(kUrls.usersBaseUrl)/?\(searchOptions.urlParams())"
            str = str.replacingOccurrences(of: "+", with: "%2B")
            return str
        }
        
        func parse(_ json: JSON) -> Page<User> {

            let currentPage = json["page"] as! Int
            let totalPages = json["total_pages"] as! Int
            let totalCount = json["total_count"] as! Int

            guard let usersDics = json["users"] as? [[String: Any]] else {

                return Page<User>(items: [], currentPage: currentPage, totalPages: totalPages, totalCount: totalCount)
            }

            let users = usersDics.compactMap { User(from: $0) }

            return Page(items: users, currentPage: currentPage, totalPages: totalPages, totalCount: totalCount)
        }
    }
}
