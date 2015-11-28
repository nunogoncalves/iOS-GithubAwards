//
//  GetUsers.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class GetUsers {

    private let baseUrl = "http://localhost:2000/api/v0/users"
    
    private let searchOptions: SearchOptions
    
    init(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
    }
    
    func fetch() {
        let url = "\(baseUrl)/?\(searchOptions.urlEncoded())"
        print(url)
        let responseHandler = NetworkResponse()
        responseHandler.failureCallback = {
            print("failure in get users")
        }
        responseHandler.successCallback = { data in
            let paginator = Paginator(dictionary: data).currentPage
            paginator
            ConvertUsersDictionaryToUsers(data: data)
        }
        
        NetworkRequester.makeGet(url, networdResponseHandler: responseHandler)
    }
    
}