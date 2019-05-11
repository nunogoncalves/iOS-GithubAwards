//
//  Browser.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class Browser {
    
    static func openPage(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
