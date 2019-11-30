//
//  AppDelegate.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        initialSetup()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController(
            main: MainCoordinator(navigationController: UINavigationController()),
            users: UsersCoordinator(navigationController: UINavigationController()),
            trending: TrendingCoordinator(navigationController: UINavigationController()),
            settings: SettingsCoordinator(navigationController: UINavigationController())
        )
        window?.makeKeyAndVisible()

        return true
    }
}
