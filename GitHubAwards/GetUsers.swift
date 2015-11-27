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
        print("\(baseUrl)/?\(searchOptions.urlEncoded())")
    }
    
}