//
//  InitialSetup.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/11/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

#if DEBUG
import netfox
#endif

func initialSetup() {
    setupStyle()
    
    Cache.configure()
    Analytics.configureGoogle()

    #if DEBUG

    NFX.sharedInstance().start()
    ["", "0", "1", "2", "3"]
        .map { "https://avatars\($0).githubusercontent.com" }
        .forEach { NFX.sharedInstance().ignoreURL($0) }

    Mocks.configure()
    #endif
}

