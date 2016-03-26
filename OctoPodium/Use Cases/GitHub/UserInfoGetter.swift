//
//  UserInfoGetter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    struct UserInfoGetter : Getter {
        
        func get(success success: User -> (), failure: NetworkStatus -> ()) {
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                
                let responseHandler = Data.ResponseHandler()
                responseHandler.failureCallback = { apiResponse in
                    dispatch_async(dispatch_get_main_queue()) {
                        failure(apiResponse.status)
                    }
                }
                responseHandler.successCallback = { dictionary in
                    let user = self.getDataFrom(dictionary)
                    dispatch_async(dispatch_get_main_queue()) {
                        success(user)
                    }
                }
                
                var headerParams: [String : String] = [:]
                if let token = GithubToken.instance.token {
                    headerParams["Authorization"] = "token \(token)"
                }
                Network.Requester(networkResponseHandler: responseHandler).makeGet(self.getUrl(),headerParameters: headerParams)
            }
        }
        
        func getDataFrom(dictionary: NSDictionary) -> User {
            return User(
                login: dictionary["login"] as? String ?? "",
                avatarUrl: dictionary["avatar_url"] as? String ?? ""
            )
        }
        
        func getUrl() -> String {
            return kUrls.userUrl
        }
        
    }
}
