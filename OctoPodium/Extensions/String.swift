//
//  String.swift
//  OctoPodium
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

    func withoutSpaces() -> String {
        return replace(" ", with: "")
            .replace("\n", with: "")
    }
    
    func replace(str: String, with w: String) -> String {
        return stringByReplacingOccurrencesOfString(str, withString: w)
    }
    
    func substringBetween(from: String, and to: String) -> String? {
        let range = rangeOfString("(?<=\(from))(.*?)(?=\(to))", options: .RegularExpressionSearch)
        guard range != nil else { return nil }
        return self.substringWithRange(range!)
    }
    
    func substringUntil(until: String) -> String? {
        let range = rangeOfString(until)
        guard range != nil else { return nil }
        return self.substringToIndex(range!.startIndex)
    }
    
    func substringAfter(after: String) -> String? {
        let range = rangeOfString(after)
        guard range != nil else { return nil }
        return self.substringFromIndex(range!.startIndex)
    }

}
