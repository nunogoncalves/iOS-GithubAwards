//
//  AppDelegate.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
#if DEBUG
import netfox
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        Style.Decorator().decorateApp()

        Cache.configure()
        Analytics.configureGoogle()

        #if DEBUG
        NFX.sharedInstance().start()
        ["", "0", "1", "2", "3"]
            .map { "https://avatars\($0).githubusercontent.com" }
            .forEach { NFX.sharedInstance().ignoreURL($0) }
        #endif

        Mocks.configure()

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
