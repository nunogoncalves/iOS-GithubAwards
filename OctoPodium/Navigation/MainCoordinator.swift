//
//  MainCoordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

class MainCoordinator: Coordinator {

    var children: [Coordinator] = [

    ]

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let languagesController = UIStoryboard(storyboard: .main).controller(LanguagesController.self)
        languagesController.coordinator = self
        navigationController.pushViewController(languagesController, animated: false)
    }

    func showDetails(of language: Language) {
        let languageRankingController = UIStoryboard(storyboard: .main).controller(LanguageRankingsController.self)
        languageRankingController.language = language
        navigationController.pushViewController(languageRankingController, animated: true)
    }
}
