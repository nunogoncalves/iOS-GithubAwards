//
//  UsersListResponse.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

struct UsersListResponse {
    
    let users: [User]
    let paginator: Paginator
    
    init(users: [User], paginator: Paginator) {
        self.users = users
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
    
}
