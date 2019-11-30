//
//  RepoContentsFetcher.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension GitHub {
    class RepoContentFetcher : Requestable, Parameterless, HTTPGetter {
        
        private let repoName: String
        
        init(repositoryName: String) {
            self.repoName = repositoryName
        }
        
        var url: URL {
            return URL(string: "https://api.github.com/repos/\(repoName)/contents".urlEncoded())!
        }
        
        func parse(_ json: JSON) -> String {
            var readMeLocation = ""
            for item in json["response"] as! [NSDictionary] {
                let name = (item["name"] as? String) ?? ""
                if name.lowercased().contains("readme") {
                    if let url = item["html_url"] as? String {
                        readMeLocation = url
                        break
                    }
                }
            }
            return readMeLocation
        }
        
    }
}
