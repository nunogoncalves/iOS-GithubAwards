//
//  StarsAndForksFetcher.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 20/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    class StarsAndForksFetcher : Getter {
        
        var headers: HeadParams? = nil
        
        var bodyParams: BodyParams? = nil
        
        let httpMethod = HTTPMethod.GET
        
        private let repoName: String
        
        init(repositoryName: String) {
            self.repoName = repositoryName
        }
        
        func getUrl() -> String {
            return "https://api.github.com/repos/\(repoName)"
        }
        
        func getDataFrom(dictionary: NSDictionary) -> (Int, Int) {
            let stars = dictionary["stargazers_count"] as? Int ?? 0
            let forks = dictionary["forks_count"] as? Int ?? 0
            
            return (stars: stars, forks: forks)
        }
        
    }
}

