//
//  GetLanguages.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 08/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Languages {
    
    class Get: Getter {
        
        func getUrl() -> String {
            return kUrls.languagesBaseUrl
        }
        
        func getDataFrom(dictionary: NSDictionary) -> [Language] {
            return dictionary["languages"] as! [Language]
        }
    }
}