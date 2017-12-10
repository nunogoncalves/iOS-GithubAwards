//
//  CreateUserFromDictionary.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 28/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class CreateBasicUserFromDictionary {

    let user: User

    let json: JSON

    init(from json: JSON) {
        self.json = json
        user = User(from: json)
    }

}
