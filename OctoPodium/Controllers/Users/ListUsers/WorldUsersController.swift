//
//  WorldUsersController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class WorldUsersController : UsersController {

    init(language: String, topInset: CGFloat) {
        super.init(language: language, locationType: .world)
        usersTable.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        freshSearchUsers()
    }
    
    override func sendUserPaginatedToAnalytics(_ page: String) {
        Analytics.SendToGoogle.usersPaginatedInWorld(forLanguage: language, andPage: page)
    }
}
