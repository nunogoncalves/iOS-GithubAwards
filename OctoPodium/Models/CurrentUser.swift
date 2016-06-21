//
//  CurrentUser.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class CurrentUser : User {
    private func isLoggedIn() -> Bool {
        return GithubToken.instance.exists()
    }
}
