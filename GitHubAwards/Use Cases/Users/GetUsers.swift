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
    
    func fetch(success success: [User] -> (), failure: () -> ()) {
        let url = "\(baseUrl)/?\(searchOptions.urlEncoded())"

        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            
            let responseHandler = NetworkResponse()
            responseHandler.failureCallback = {
                dispatch_async(dispatch_get_main_queue()) {
                    failure()
                }
                print("failure in get users")
            }
            responseHandler.successCallback = { data in
                let paginator = Paginator(dictionary: data).currentPage
                paginator
                let users = ConvertUsersDictionaryToUsers(data: data).users
                dispatch_async(dispatch_get_main_queue()) {
                    success(users)
                }
            }
            NetworkRequester.makeGet(url, networdResponseHandler: responseHandler)
        }
        
    }
    
    func x() {
    }
}