//
//  UsersCoordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

class UsersCoordinator: Coordinator {
    let navigationController: UINavigationController
    let children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let usersController = UIStoryboard(storyboard: .main).controller(with: "UsersSearchController") as UsersSearchController
        usersController.coordinator = self
        navigationController.pushViewController(usersController, animated: false)
    }
}
