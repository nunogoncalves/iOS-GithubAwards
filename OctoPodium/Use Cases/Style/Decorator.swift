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
            tabBarAppearance.tintColor = .white
            tabBarAppearance.barTintColor = .tabBarColor
        }
        
        private func setUpNavigationAppearance() {
            let appearance = UINavigationBar.appearance()
            appearance.barStyle = .black
            appearance.barTintColor = .navigationBarColor
            appearance.tintColor = .white
            
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
            ]
        }

    }
}
