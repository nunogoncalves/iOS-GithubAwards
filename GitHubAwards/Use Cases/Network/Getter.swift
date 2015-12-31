//
//  Getter.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 30/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol Getter {
    typealias Element
    
    func getUrl() -> String
    
    func getDataFrom(dictionary: NSDictionary) -> Element
    
    func get(success success: Element -> (), failure: () -> ())
    
}

extension Getter {
    func get(success success: Element -> (), failure: () -> ()) {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            
            let responseHandler = Data.HandleResponse()
            responseHandler.failureCallback = {
                dispatch_async(dispatch_get_main_queue()) {
                    failure()
                }
            }
            responseHandler.successCallback = { dictionary in
                let data = self.getDataFrom(dictionary)
                dispatch_async(dispatch_get_main_queue()) {
                    success(data)
                }
            }
            Network.Requester(networkResponseHandler: responseHandler).makeGet(self.getUrl())
        }
    }
}