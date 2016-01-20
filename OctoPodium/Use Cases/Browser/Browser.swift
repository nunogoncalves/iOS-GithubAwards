//
//  Browser.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class Browser {
    
    static func openPage(url: String) {
        let url = NSURL(string: url)
        UIApplication.sharedApplication().openURL(url!)
    }
    
}
