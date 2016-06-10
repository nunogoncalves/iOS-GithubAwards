//
//  ConfigureImagesCache.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import SDWebImage

struct Cache {
    struct Configure {
    
        init() {
            SDWebImageManager.sharedManager().imageCache.maxCacheAge = 60 * 60 * 24 * 31
            let URLCache = NSURLCache(
                memoryCapacity: 4 * 1024 * 1024,
                diskCapacity: 20 * 1024 * 1024,
                diskPath: nil)
            
            NSURLCache.setSharedURLCache(URLCache)
        }
        
    }
}
