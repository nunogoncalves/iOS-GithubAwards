//
//  StarChecker.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    
    struct StarChecker : Requestable, EmptyBody, HTTPGetter {
        
        let repoOwner: String
        let repoName: String
        
        init(repoOwner: String, repoName: String) {
            self.repoOwner = repoOwner
            self.repoName = repoName
        }
        
        var headers: HeadParams? = [
            "Authorization" : "token \(GithubToken.instance.token ?? "")"
        ]
        
        var url: URL {
            return URL(string: kUrls.githubStarredRepoUrl(repoOwner, repoName).urlEncoded())!
        }

        func parse(_ json: JSON) -> Bool {
            return true
        }
        
        func checkIfIsStar(success: @escaping (Bool) -> (), failure: @escaping (ApiResponse) -> ()) {
            call(success: { starred -> () in
                    success(starred)
                 },
                 failure: { apiResponse in
                    if apiResponse.status == .notFound {
                        success(false)
                    } else {
                        failure(apiResponse)
                    }
                }
            )
        }

    }
    
}
