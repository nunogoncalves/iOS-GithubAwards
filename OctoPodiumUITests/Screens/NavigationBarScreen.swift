//
//  NavigationBarScreen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

protocol NavigationBarScreen: Screen {

    var backButton: XCUIElement { get }
    var navigationBarIdentifier: String { get }

    func goBack()
}

extension NavigationBarScreen {

    var navigationBar: XCUIElement {
        
        return app.navigationBars[navigationBarIdentifier]
    }
    
    var backButton: XCUIElement {
        
        return navigationBar.buttons[""]
    }
    
    func goBack() {
        
        self.backButton.tap()
    }
}

private extension ElementName {

}
