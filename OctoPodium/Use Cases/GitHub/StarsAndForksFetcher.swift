//
//  StarsAndForksFetcher.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 20/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    class StarsAndForksFetcher : Requestable, Parameterless, HTTPGetter {
        
        private let repoName: String
        
        init(repositoryName: String) {
            self.repoName = repositoryName
        }
        
        var url: URL {
            return URL(string: "https://api.github.com/repos/\(repoName)".urlEncoded())!
        }
        
        func parse(_ json: JSON) -> (Int, Int) {
            let stars = json["stargazers_count"] as? Int ?? 0
            let forks = json["forks_count"] as? Int ?? 0
            
            return (stars: stars, forks: forks)
        }
        
    }
}

