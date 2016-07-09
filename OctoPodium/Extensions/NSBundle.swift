//
//  NSBundle.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension Bundle {
    
    class func versionNumber() -> String {
        return stringFor("CFBundleShortVersionString") ?? ""
    }
 
    class func stringFor(_ key: String) -> String? {
        return Bundle.main().objectForInfoDictionaryKey(key) as? String
    }
}
