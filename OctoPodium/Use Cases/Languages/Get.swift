//
//  GetLanguages.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 08/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol LanguageServiceProtocol {

    func getAll(then: @escaping (Result<[Language], ApiResponseError>) -> ())
}

struct Languages {
    
    class Get: LanguageServiceProtocol, Requestable, Parameterless, HTTPGetter {
        
        private static var languages: [Language] = []

        func getAll(then: @escaping (Result<[Language], ApiResponseError>) -> ()) {
            if Languages.Get.languages.isEmpty {
                call(
                    success: { then(.success($0)) },
                    failure: { then(.failure(.any(apiResponse: $0))) }
                )
            } else {
                then(.success(Languages.Get.languages))
            }
        }

        var url: URL {
            return URL(string: "\(kUrls.languagesBaseUrl)?sort=popularity".urlEncoded())!
        }
        
        func parse(_ json: JSON) -> [Language] {
            return json["languages"] as! [Language]
        }
    }
}
