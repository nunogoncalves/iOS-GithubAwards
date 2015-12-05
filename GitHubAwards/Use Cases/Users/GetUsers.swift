//
//  GetUsers.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class GetUsers {

    private let baseUrl = "http://localhost:2000/api/v0/users"
    
    private let searchOptions: SearchOptions
    
    init(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
    }
    
    func fetch(success success: UsersListResponse -> (), failure: () -> ()) {
        let url = "\(baseUrl)/?\(searchOptions.urlEncoded())"
        print(url)

        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            
            let responseHandler = NetworkResponse()
            responseHandler.failureCallback = {
                dispatch_async(dispatch_get_main_queue()) {
                    failure()
                }
            }
            responseHandler.successCallback = { data in
                let paginator = Paginator(dictionary: data)
                let users = ConvertUsersDictionaryToUsers(data: data).users
                let usersResponse = UsersListResponse(users: users, paginator: paginator)
                dispatch_async(dispatch_get_main_queue()) {
                    success(usersResponse)
                }
            }
            NetworkRequester.makeGet(url, networdResponseHandler: responseHandler)
        }
        
    }
    
    func x() {
    }
}