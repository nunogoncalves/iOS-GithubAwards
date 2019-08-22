//
//  ImageMocker.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 22/08/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import OHHTTPStubs

protocol ImageMocker {
    func mockImages()
}

extension ImageMocker {

    func mockImages() {
        stub(
            condition: { request in request.isImageResource },
            response: { request in self.imageMock }
        )
    }

    private var imageMock: OHHTTPStubsResponse {
        let stubPath = OHPathForFileInBundle("nuno.jpeg", Bundle.main)!
        return fixture(filePath: stubPath, headers: ["Content-Type":"image/jpeg"])
    }
}

extension TimeInterval {

    static let loadingTime: TimeInterval = 0.3
    static let longLoadingTime: TimeInterval = 1.0
}

extension URLRequest {

    private static let imageTypes = ["jpg", "png", "jpeg"]

    var isImageResource: Bool {

        guard let url = self.url else { return false }

        return URLRequest.imageTypes.contains(url.pathExtension)
    }
}
