//
//  Follow.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct Twitter {

    struct Follow {
        
        init(username: String) {
            let twitterURLs = [
                "twitter://user?screen_name=\(username)", // Twitter
                "tweetbot://user_profile/\(username)", // TweetBot
                "echofon://user_timeline?\(username)", // Echofon
                "twit://user?screen_name=\(username)", // Twittelator Pro
                "x-seesmic://twitter_profile?twitter_screen_name=\(username)", // Seesmic
                "x-birdfeed://user?screen_name=\(username)", // Birdfeed
                "tweetings://user?screen_name=\(username)", // Tweetings
                "simplytweet://?link=http://twitter.com/\(username)", // SimplyTweet
                "icebird://user?screen_name=\(username)", // IceBird
                "fluttr://user/\(username)", // Fluttr
            ]
        
            var applicationOpened: Bool = false
            let application = UIApplication.sharedApplication()
            for twitterURL in twitterURLs {
                if let url = NSURL(string: twitterURL) where application.canOpenURL(url) && !applicationOpened {
                    application.openURL(url)
                    applicationOpened = true
                    break
                }
            }
            
            if !applicationOpened {
                Browser.openPage("http://twitter.com/\(username)")
            }
        }
    }
}