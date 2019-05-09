//
//  XCTestCase.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 01/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import XCTest

extension XCTestCase {

    func waitForAppearance(
        of element: XCUIElement,
        for timeout: TimeInterval = 5,
        file: String = #file,
        line: Int = #line
    ) {

        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { error in

            if let error = error {

                let message = "Failed to find \(element) - \(element.staticTexts) in \(file):\(line) after \(timeout) seconds. \nError: \(error.localizedDescription)"
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
}
