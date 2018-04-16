//
//  MocksConfigurator.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 16/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import Foundation
import OHHTTPStubs

struct Mocks {

    static func configure() {

        #if !DEBUG

            return

        #else

            if ProcessInfo.processInfo.arguments.contains(UITestingConstants.uiTestingMode) {

                stub(condition: shouldStub, response: { stubbedResponse(for: $0) })

                return
            }

        #endif

    }

    #if DEBUG

        private static func shouldStub(_ request: URLRequest) -> Bool {

            guard let url = request.url,
                let query = url.query
                else {
                    return false
            }

            if url.path == "/trending" && query == "since=Daily" {

                return true
            }

            return false
        }

        private static func stubbedResponse(for request: URLRequest) -> OHHTTPStubsResponse {

            let bundle = Bundle.main
            let string = bundle.path(forResource: "trending_repositories", ofType: "html")!
            let data = try! String(contentsOfFile: string, encoding: .utf8).data(using: .utf8)!

            return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }

    #endif
}
