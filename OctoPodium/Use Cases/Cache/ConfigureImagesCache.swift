//
//  ConfigureImagesCache.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Nuke

struct Cache {

    static func configure() {

        // Configure cache
        ImageCache.shared.costLimit = 1024 * 1024 * 10 // 10 MB
        ImageCache.shared.countLimit = 1000
        ImageCache.shared.ttl = 1.month // Invalidate image after 1 month
    }
}

private extension TimeInterval {
    var month: TimeInterval { return 60 * 60 * 24 * 30 }
}
