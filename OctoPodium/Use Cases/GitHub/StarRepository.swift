//
//  StarRepository.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 28/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    
    struct StartRepository : Getter {
        
        let repoOwner: String
        let repoName: String
        
        init(repoOwner: String, repoName: String) {
            self.repoOwner = repoOwner
            self.repoName = repoName
        }
        
        var httpMethod = HTTPMethod.PUT
        
        var headers: HeadParams? = [
            "Content-Length" : "0",
            "Authorization" : "token \(GithubToken.instance.token ?? "")"
        ]
        
        var bodyParams: BodyParams? = nil
        
        func getUrl() -> String {
            return kUrls.doStarRepoUrl(repoOwner, repoName)
        }

        func getDataFrom(dictionary: NSDictionary) {}
        
        func doStar(success: () -> (), failure: ApiResponse -> ()) {
            call(success: success, failure: failure)
        }
    }
}
