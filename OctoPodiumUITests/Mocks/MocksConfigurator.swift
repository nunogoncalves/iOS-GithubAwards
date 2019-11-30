//
//  MocksConfigurator.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 16/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

#if DEBUG

import Foundation
import UIKit
import OHHTTPStubs

struct Mocks {

    static func configure() {

        if isRunningUITests {
            UIView.setAnimationsEnabled(false)
            stub(condition: shouldStub, response: { stubbedResponse(for: $0)! })
            return
        }
    }

    private static func shouldStub(_ request: URLRequest) -> Bool {

        guard let url = request.url else { return false }

        switch (url.path, url.query) {
        case ("/trending", "since=Daily"),
             ("/api/v0/languages", _),
             ("/api/v0/users", "language=javascript&type=world&page=1"),
             ("/api/v0/users/facebook", _):
            return true
        default:
            return false
        }
    }

    private static func stubbedResponse(for request: URLRequest) -> OHHTTPStubsResponse? {

        guard let url = request.url else { return nil }

        switch (url.path, url.query) {
        case ("/trending", "since=Daily"):
            let string = Bundle.main.path(forResource: "trending_repositories", ofType: "html")!
            let data = try! String(contentsOfFile: string, encoding: .utf8).data(using: .utf8)!

            return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        case ("/api/v0/languages", _):
            return OHHTTPStubsResponse(jsonObject: languages, statusCode: 200, headers: nil)
        case ("/api/v0/users", "language=javascript&type=world&page=1"):
            return OHHTTPStubsResponse(jsonObject: javascriptRanking, statusCode: 200, headers: nil)
        case ("/api/v0/users/facebook", _):
            return OHHTTPStubsResponse(jsonObject: facebook, statusCode: 200, headers: nil)
        default:
            return nil
        }
    }
}

private var isRunningUITests: Bool {
    return ProcessInfo.processInfo.arguments.contains(UITestingConstants.uiTestingMode)
}

#endif
