//
//  SendToGoogle.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct Analytics {
    
    private static let tracker = GAI.sharedInstance().defaultTracker
    private static let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
    
    static func sendScreenInfoToGoogle(screenName: String) {
        callAsync {
            sendScreenViewToGoogle(screenName)
        }
    }

    static func sendSearchedCountry(country: String, forLanguage language: String) {
        callAsync {
            sendEventToGoogle("Search", action: "Country<\(country)|\(language)>", label: "\(country)|\(language)")
        }
    }
    
    static func sendSearchedCity(city: String, forLanguage language: String) {
        callAsync {
            sendEventToGoogle("Search", action: "City<\(city)|\(language)>", label: "\(city)|\(language)")
        }
    }
    
    static func sendEventUserSearchedToGoogle(login: String) {
        callAsync {
            sendEventToGoogle("Search", action: "User<\(login)>", label: login)
        }
    }
    
    static func sendViewOnGithubAction(login: String) {
        callAsync {
            sendEventToGoogle("Show", action: "UserGithub<\(login)>", label: login)
        }
    }
    
    static func sendRankingClicked(login: String, language: String) {
        callAsync {
            sendEventToGoogle("Show", action: "UserRepositories<\(login)-\(language)>", label: "\(login)-\(language)")
        }
    }
    
    private static func callAsync(closure: () -> ()) {
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            closure()
        }
    }
    
    private static func sendScreenViewToGoogle(screenName: String) {
        #if RELEASE
            tracker.set(kGAIScreenName, value: screenName)
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker.send(builder.build() as [NSObject : AnyObject])
        #endif
    }
    
    private static func sendEventToGoogle(category: String, action: String, label: String) {
        #if RELEASE
            let builder = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: nil)
            tracker.send(builder.build() as [NSObject : AnyObject])
        #endif
    }
}
