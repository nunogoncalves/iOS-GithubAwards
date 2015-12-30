//
//  GetLanguages.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 08/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class GetLanguages {
    
    func fetch(success success: [Language] -> (),
               failure: () -> ()) {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
                
            let responseHandler = Data.HandleResponse()
            responseHandler.failureCallback = {
                dispatch_async(dispatch_get_main_queue()) {
                    failure()
                }
            }
            responseHandler.successCallback = { data in
                let languages = data["languages"] as! [Language]
                dispatch_async(dispatch_get_main_queue()) {
                    success(languages)
                }
            }
            Network.Requester(networkResponseHandler: responseHandler).makeGet(K.languagesBaseUrl)
        }
    }
}
