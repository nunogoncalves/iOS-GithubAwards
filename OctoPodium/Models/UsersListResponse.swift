//
//  UsersListResponse.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

struct UsersListResponse : Book {
    
    var users: [User]
    var paginator: Paginator
    
    var data: [AnyObject]
    
    init(users: [User], paginator: Paginator) {
        self.users = users
        data = users
        self.paginator = paginator
    }
    
    func isFirstPage() -> Bool {
        return paginator.isFirstPage()
    }
    
    func isLastPage() -> Bool {
        return paginator.isLastPage()
    }
    
    func hasMoreUsers() -> Bool {
        return paginator.hasMorePages()
    }
    
    func hasMorePages() -> Bool {
        return hasMoreUsers()
    }
}
