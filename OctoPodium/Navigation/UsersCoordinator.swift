//
//  UsersCoordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

class UsersCoordinator: Coordinator, UserDisplayCoordinator {
    
    let navigationController: UINavigationController
    let children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let usersController = UsersSearchController(coordinator: self)
        navigationController.pushViewController(usersController, animated: false)
    }
}
