//
//  ConvertUsersDictionaryToUsers.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class ConvertUsersDictionaryToUsers {
    
    private let data: JSON
    
    var users: [User] = []
    
    init(data: JSON) {
        self.data = data
        buildUsers()
    }
    
    private func buildUsers() {
        guard let dataUsers = data["users"] as? [JSON] else {
            return
        }

        users = dataUsers.compactMap { User(from: $0) }
    }
}
