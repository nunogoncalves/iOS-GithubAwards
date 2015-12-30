//
//  SearchUser.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 28/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class GetUser {

    private let login: String
    
    init(login: String) {
        self.login = login
    }
    
    func fetch(success: (User -> ()),
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
                let user = CreateFullUserFromDictionary(userDic: data["user"]! as! NSDictionary).user
                dispatch_async(dispatch_get_main_queue()) {
                    success(user)
                }
            }
//            let url = "\(K.usersBaseUrl)/\(self.login)"
            let url = "\(K.usersBaseUrl)/nunogoncalves"
            Network.Requester(networkResponseHandler: responseHandler).makeGet(url)
        }
    }
}