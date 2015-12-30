//
//  GetUsers.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class GetUsers {

    private let searchOptions: SearchOptions
    
    init(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
    }
    
    func fetch(success success: UsersListResponse -> (),
               failure: () -> ()) {
        let url = "\(K.usersBaseUrl)/?\(searchOptions.urlEncoded())"

        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            
            let responseHandler = Data.HandleResponse()
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
            NetworkRequester(networkResponseHandler: responseHandler).makeGet(url)
        }
        
    }
}