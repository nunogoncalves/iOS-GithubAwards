//
//  UnstarRepository.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    
    class UnstarRepository : Requestable, EmptyBody, HTTPDeleter {
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
        
        var url: URL {
            return URL(string: kUrls.doUnstarRepoUrl(repoOwner, repoName).urlEncoded())!
        }
        
        func parse(_ json: JSON) -> Void {}
        
        func doUnstar(success: @escaping () -> (), failure: @escaping (ApiResponse) -> ()) {
            call(success: success, failure: failure)
        }
    }
    
}
