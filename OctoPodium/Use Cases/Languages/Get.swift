//
//  GetLanguages.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 08/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Languages {
    
    class Get: Getter {
        
        private static var languages = [Language]()
        
        func getAll(success success: [Language] -> (), failure: NetworkStatus -> ()) {
            if Languages.Get.languages.count == 0 {
                get(success: success, failure: failure)
            } else {
                success(Languages.Get.languages)
            }
        }

        func getUrl() -> String {
            return "\(kUrls.languagesBaseUrl)?sort=popularity"
        }
        
        func getDataFrom(dictionary: NSDictionary) -> [Language] {
            return dictionary["languages"] as! [Language]
        }
    }
}