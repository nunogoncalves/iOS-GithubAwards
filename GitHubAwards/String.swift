//
//  String.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 01/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension String {
    func urlEncoded() -> String {
        let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        return self.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
    }

}
