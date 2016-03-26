//
//  Login.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    struct Login {
        
        private let user: String
        private let password: String
        private let twoFactorAuth: String?
        
        private let githubClientId = AppConfigurations.GithubConfigurations.instance.clientId
        private let githubClientSecret = AppConfigurations.GithubConfigurations.instance.clientSecret
        
        init(user: String, password: String, twoFactorAuth: String?) {
            self.user = user
            self.password = password
            self.twoFactorAuth = twoFactorAuth
        }
        
        func login(success: String -> (), failure: ApiResponse -> ()) {
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                
                let responseHandler = Data.ResponseHandler()
                responseHandler.failureCallback = { apiResponse in
                    dispatch_async(dispatch_get_main_queue()) {
                        failure(apiResponse)
                    }
                }
                responseHandler.successCallback = { dictionary in
                    let token = self.getDataFrom(dictionary)
                    dispatch_async(dispatch_get_main_queue()) {
                        success(token)
                    }
                }
                
                let bodyParams: [String : AnyObject] = [
                    "note" : "OctoPodium",
                    "client_id" : self.githubClientId,
                    "client_secret" : self.githubClientSecret,
                    "scopes" : ["user:follow", "public_repo"]
                ]
                
                let loginString = "\(self.user):\(self.password)"
                let loginData: NSData = loginString.dataUsingEncoding(NSASCIIStringEncoding)!
                let base64LoginString = loginData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let authorizationHeaderStr = "Basic \(base64LoginString)"

                var headerParams = [
                    "Authorization" : authorizationHeaderStr,
                ]
                
                if let twoFA = self.twoFactorAuth {
                    headerParams["X-GitHub-OTP"] = twoFA
                }
                
                Network.Requester(networkResponseHandler: responseHandler).makePost(kUrls.githubLoginUrl,
                                              headerParameters: headerParams,
                                              bodyParameters: bodyParams)
            }
        }
        
        func getDataFrom(dictionary: NSDictionary) -> String {
            return dictionary["token"] as! String
        }

    }
}
