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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setUpBarsAppearance()
        configureCache()
        configureGoogleAnalytics()
       
        return true
    }

    private func setUpBarsAppearance() {
        setUpTabsAppearance()
        setUpNavigationAppearance()
    }

    private func configureCache() {
        let URLCache = NSURLCache(
            memoryCapacity: 4 * 1024 * 1024,
            diskCapacity: 20 * 1024 * 1024,
            diskPath: nil)
        
        NSURLCache.setSharedURLCache(URLCache)
    }
    
    private func configureGoogleAnalytics() {
        let gai = GAI.sharedInstance()
        
        gai.logger.logLevel = .None
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
    }
    
    private func setUpTabsAppearance() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .whiteColor()
        tabBarAppearance.barTintColor = UIColor(rgbValue: kColors.tabBarColor)
    }
    
    private func setUpNavigationAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor(rgbValue: kColors.navigationBarColor)
        appearance.tintColor = .whiteColor()
        
        appearance.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {}


}

