//
//  SettingsCoordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

class SettingsCoordinator: Coordinator {
    let navigationController: UINavigationController
    let children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let settingsController = UIStoryboard(storyboard: .main).controller(SettingsController.self)
        settingsController.coordinator = self
        navigationController.pushViewController(settingsController, animated: false)
    }

    func showDetails(of repository: Repository) {
        let repositoryController = UIStoryboard(storyboard: .main).controller(RepositoryDetailsController.self)
        repositoryController.repository = repository
        navigationController.pushViewController(repositoryController, animated: true)
    }
}
