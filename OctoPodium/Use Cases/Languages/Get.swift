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
        
        var headers: HeadParams? = nil
        
        var bodyParams: BodyParams? = nil
        
        let httpMethod = HTTPMethod.GET
        
        private static var languages = [Language]()
        
        private var successLangs: ([Language] -> ())?
        
        func getAll(success success: [Language] -> (), failure: ApiResponse -> ()) {
            successLangs = success
            if Languages.Get.languages.count == 0 {
                call(success: gotLanguages, failure: failure)
            } else {
                success(Languages.Get.languages)
            }
        }
        
        private func gotLanguages(languages: [Language]) {
            Languages.Get.languages = languages
            successLangs?(languages)
        }

        func getUrl() -> String {
            return "\(kUrls.languagesBaseUrl)?sort=popularity"
        }
        
        func getDataFrom(dictionary: NSDictionary) -> [Language] {
            return dictionary["languages"] as! [Language]
        }
    }
}