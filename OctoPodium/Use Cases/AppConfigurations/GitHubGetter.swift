//
//  GithubConfigsGetter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct AppConfigurations {

    struct GitHubGetter {
        
        static let instance = AppConfigurations.GitHubGetter()
        
        let clientId: String
        let clientSecret: String
        
        private init() {
            let pListPath = Bundle.main.path(forResource: "Github", ofType: "plist")
            let content = NSDictionary(contentsOfFile: pListPath!)
            clientId = content!["ClientId"] as! String
            clientSecret = content!["ClientSecret"] as! String
        }
        
    }
}
