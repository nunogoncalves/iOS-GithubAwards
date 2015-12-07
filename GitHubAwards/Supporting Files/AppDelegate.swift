//
//  AppDelegate.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setUpBarsAppearance()
       
        return true
    }

    private func setUpBarsAppearance() {
        setUpTabsAppearance()
        setUpNavigationAppearance()
    }
    
    private func setUpTabsAppearance() {
        UITabBar.appearance().tintColor = .whiteColor()
        UITabBar.appearance().barTintColor = UIColor.fromHex(K.navAndTabBarsColor)
    }
    
    private func setUpNavigationAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.fromHex(K.navAndTabBarsColor)
        UINavigationBar.appearance().tintColor = .whiteColor()
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]

    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {}


}

