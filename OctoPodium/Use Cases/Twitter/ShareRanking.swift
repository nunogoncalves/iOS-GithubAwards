//
//  ShareRanking.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 13/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension Twitter {
    
    struct Share {
        init(ranking: String, language: String, location: String) {
            let application = UIApplication.shared()
            let text = "I am the top \(ranking) \(language) developer in \(location). Check your GitHub ranking on #Octopodium #github-awards!".urlEncoded()
            
            let twitterUrl = "twitter://post?message=\(text))"
            
            if let url = URL(string: twitterUrl) where application.canOpenURL(url) {
                Analytics.SendToGoogle.shareRankingOnTwitterEvent("Twitter")
                application.openURL(url)
            } else {
                Analytics.SendToGoogle.shareRankingOnTwitterEvent("Browser")
                Browser.openPage("https://twitter.com/intent/tweet?text=\(text)")
            }
        }
        
    }
    
}
