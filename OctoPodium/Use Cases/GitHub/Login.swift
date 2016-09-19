//
//  Login.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    struct Login: Requestable, HTTPPoster {
        
        var headers: HeadParams? = nil
        
        var bodyParams: BodyParams? = [
            "note" : "OctoPodium",
            "client_id" : AppConfigurations.GitHubGetter.instance.clientId,
            "client_secret" : AppConfigurations.GitHubGetter.instance.clientSecret,
            "scopes" : ["user:follow", "public_repo"]
        ]
        
        private let user: String
        private let password: String
        private let twoFactorAuth: String?
        
        init(user: String, password: String, twoFactorAuth: String?) {
            self.user = user
            self.password = password
            self.twoFactorAuth = twoFactorAuth

            buildHeaders()
        }
        
        func login(_ success: @escaping (String) -> (), failure: @escaping (ApiResponse) -> ()) {
            call(success: success, failure: failure)
        }
        
        private mutating func buildHeaders() {
            let loginString = "\(user):\(password)"
            let authorizationHeaderStr = "Basic \(loginString.base64Encoded())"
            
            headers = ["Authorization" : authorizationHeaderStr]
            
            if let twoFA = twoFactorAuth {
                headers!["X-GitHub-OTP"] = twoFA
            }
        }
        
        func getUrl() -> String {
            return kUrls.githubLoginUrl
        }
        func getDataFrom(_ dictionary: NSDictionary) -> String {
            return dictionary["token"] as! String
        }

    }
}
