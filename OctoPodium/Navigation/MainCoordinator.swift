//
//  MainCoordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol UserDisplayCoordinator: Coordinator {
    func showDetails(of user: User)
}

extension UserDisplayCoordinator {

    func showDetails(of user: User) {
        let userDetailsController = UserDetailsController(user: user)
        navigationController.pushViewController(userDetailsController, animated: true)
    }
}

class MainCoordinator: Coordinator, UserDisplayCoordinator {

    var children: [Coordinator] = [

    ]

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let languagesController = LanguagesController(languagesFetcher: Languages.Get(), coordinator: self)
        navigationController.pushViewController(languagesController, animated: false)
    }

    func showDetails(of language: Language) {
        let languageRankingController = LanguageRankingsController(language: language)
        navigationController.pushViewController(languageRankingController, animated: true)
    }
}
