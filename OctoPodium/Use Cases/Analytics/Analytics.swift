//
//  Analytics.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 28/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct Analytics {

    static func shouldUse() -> Bool {
        #if RELEASE
            return true
        #endif
        return false
    }
    
}
