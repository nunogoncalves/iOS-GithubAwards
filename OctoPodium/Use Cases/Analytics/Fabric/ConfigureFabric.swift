//
//  ConfigureFabric.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/07/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Fabric
import Crashlytics

extension Analytics {
    
    struct ConfigureFabric {
        
        init() {
            Fabric.with([Crashlytics.self])
        }
        
    }
}
    
