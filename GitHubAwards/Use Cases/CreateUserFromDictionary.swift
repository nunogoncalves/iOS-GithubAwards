//
//  CreateUserFromDictionary.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 28/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class CreateUserFromDictionary {
    
    let user: User
    
    init(userDic: NSDictionary) {
       user = User(login: (userDic["login"] ?? "") as! String,
                   avatarUrl: (userDic["gravatar_url"] ?? "") as! String)
    }
    
}