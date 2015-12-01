//
//  SearchUser.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 28/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class SearchUser {
    private let baseUrl = "http://localhost:2000/api/v0/users/search"
    
    private let login: String
    
    init(login: String) {
        self.login = login
    }
    
    func fetch(success: (User -> ())) {
        let url = "\(baseUrl)/?login=\(login)"

        let responseHandler = NetworkResponse()
        responseHandler.failureCallback = {}
        
        responseHandler.successCallback = { userDic in
            let users = CreateUserFromDictionary(userDic: userDic).user
            success(users)
        }
        
        NetworkRequester.makeGet(url, networdResponseHandler: responseHandler)
    }
}