//
//  StarRepository.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 28/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    
    struct StarRepository : Requestable, EmptyBody, HTTPPutter {
        
        let repoOwner: String
        let repoName: String
        
        init(repoOwner: String, repoName: String) {
            self.repoOwner = repoOwner
            self.repoName = repoName
        }
        
        var headers: HeadParams? = [
            "Content-Length" : "0",
            "Authorization" : "token \(GithubToken.instance.token ?? "")"
        ]
        
        var url: String {
            return kUrls.doStarRepoUrl(repoOwner, repoName)
        }

        func parse(_ json: JSON) -> Void {}
        
        func doStar(_ success: @escaping () -> (), failure: @escaping (ApiResponse) -> ()) {
            call(success: success, failure: failure)
        }
    }
}
