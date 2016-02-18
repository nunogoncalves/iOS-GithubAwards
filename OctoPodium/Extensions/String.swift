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
        let range = rangeOfString(after)?.startIndex.advancedBy(1)
        guard range != nil else { return nil }
        return self.substringFromIndex(range!)
    }

    /** Joins two strings with a separator charecter. If at least one of them is nil, the seperator character is not added. */
     /// * join(" | ", "hello", "world") produces "hello | world"
     /// * join(" | ", "hello", nil) produces "hello"
     /// * join(" | ", nil, "world") produces "world"
     /// * join(" | ", nil, nil) produces ""
    static func join(separator: String, _ str1: String?, _ str2: String?) -> String {
        if (str1 != nil && !str1!.isEmpty && str2 != nil && !str2!.isEmpty) {
            return "\(str1!)\(separator)\(str2!)"
        }
        if (str1 != nil) { return str1! }
        if (str2 != nil) { return str2! }
        
        return ""
    }
}
