//
//  NSBundle.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension NSBundle {
    
    class func versionNumber() -> String {
        return stringFor("CFBundleShortVersionString") ?? ""
    }
 
    class func stringFor(key: String) -> String? {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(key) as? String
    }
}
