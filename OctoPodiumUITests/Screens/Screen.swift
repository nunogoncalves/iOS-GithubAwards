//
//  Screen.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest
import FBSnapshotTestCase

typealias ElementName = String
typealias CellIndex = Int

protocol Screen {

    var app: XCUIApplication { get }
    var testCase: XCTestCase { get }

    func waitUntilLoaded()

    static var screenName: String { get }
}

extension Screen {

    static var screenName: String {
        
        return String(describing: self)
    }

    @discardableResult
    func takeASnapshot(named name: String = Self.screenName) -> Self {

        snapshot(name: name)

        return self
    }

    @discardableResult
    func verifyScreenView(with identifier: String) -> Self {

        guard let testCase = self.testCase as? FBSnapshotTestCase else { return self }

        let imageView = UIImageView(image: app.screenshot().image.removingStatusBar!)
        testCase.FBSnapshotVerifyView(imageView, identifier: identifier)

        return self
    }
}
