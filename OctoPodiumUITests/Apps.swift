//
//  Apps.swift
//  ShopfloorUITests
//
//  Created by Nuno Gonçalves on 20/04/2018.
//  Copyright © 2018 Farfetch. All rights reserved.
//

import XCTest

enum App: String {

    case thombrowne
    case browns
    case tage

    var bundleIdentifier: String {

        return "com.farfetch.sof.shopfloor.\(self.rawValue).debug"
    }

}

extension XCUIApplication {

    convenience init(app: App) {

        self.init(bundleIdentifier: app.bundleIdentifier)
    }
}
