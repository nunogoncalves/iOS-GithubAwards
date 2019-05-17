//
//  TrendingCoordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

class TrendingCoordinator: Coordinator {
    let navigationController: UINavigationController
    let children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let trendingController = UIStoryboard(storyboard: .main).controller(TrendingController.self)
        trendingController.coordinator = self
        navigationController.pushViewController(trendingController, animated: false)
    }
}
