//
//  ConvertUsersDictionaryToUsers.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class ConvertUsersDictionaryToUsers {
    
    private let data: NSDictionary
    
    var users = [User]()
    
    init(data: NSDictionary) {
        self.data = data
        buildUsers()
    }
    
    private func buildUsers() {
        guard let dataUsers = data["users"] as? Array<NSDictionary> else {
            return
        }
        for u in dataUsers {
            users.append(CreateUserFromDictionary(userDic: u).user)
        }
    }
}