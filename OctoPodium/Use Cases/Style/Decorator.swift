//
//  Decorator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct Style {
    struct Decorator {
        
        func decorateApp() {
            setUpTabsAppearance()
            setUpNavigationAppearance()
        }

        private func setUpTabsAppearance() {
            let tabBarAppearance = UITabBar.appearance()
            tabBarAppearance.tintColor = .white()
            tabBarAppearance.barTintColor = UIColor(hex: kColors.tabBarColor)
        }
        
        private func setUpNavigationAppearance() {
            let appearance = UINavigationBar.appearance()
            appearance.barStyle = .black
            appearance.barTintColor = UIColor(hex: kColors.navigationBarColor)
            appearance.tintColor = .white()
            
            appearance.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.white(),
            ]
        }

    }
}
