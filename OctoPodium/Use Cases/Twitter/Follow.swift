//
//  Follow.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension Twitter {

    enum TwitterClient : String {
        case Twitter = "twitter://user?screen_name="
        case TweetBot = "tweetbot://user_profile/"
        case Echofon = "echofon://user_timeline?"
        case TwittelatorPro = "twit://user?screen_name="
        case Seesmic = "x-seesmic://twitter_profile?twitter_screen_name="
        case Birdfeed = "x-birdfeed://user?screen_name="
        case Tweetings = "tweetings://user?screen_name="
        case SimplyTweet = "simplytweet://?link=http://twitter.com/"
        case IceBird = "icebird://user?screen_name="
        case Fluttr = "fluttr://user/"
        
        static func all() -> [TwitterClient] {
            return [Twitter, TweetBot, Echofon, TwittelatorPro, Seesmic,
                Birdfeed, Tweetings, SimplyTweet, IceBird, Fluttr]
        }
    }
    
    struct Follow {
        
        init(username: String) {
        
            var applicationOpened: Bool = false
            let application = UIApplication.shared
            for twitterClient in TwitterClient.all() {
                let twitterUrl = "\(twitterClient.rawValue)\(username)"
                if let url = URL(string: twitterUrl) , application.canOpenURL(url) && !applicationOpened {
                    application.open(url, options: [:], completionHandler: nil)
                    Analytics.SendToGoogle.showDeveloperOnTwitterEvent(String(describing: twitterClient))
                    applicationOpened = true
                    break
                }
            }
            
            if !applicationOpened {
                Analytics.SendToGoogle.showDeveloperOnTwitterEvent("Browser")
                Browser.openPage(URL(string: "http://twitter.com/\(username)")!)
            }
        }
    }
}
