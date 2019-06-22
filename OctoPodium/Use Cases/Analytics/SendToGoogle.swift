//
//  SendToGoogle.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension Analytics {
    
    struct SendToGoogle {
        
//        private static let tracker = GAI.sharedInstance().defaultTracker
        private static let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        
        static func enteredScreen(_ screenName: String) {
            sendScreenView(screenName)
        }
        
        static func countrySearched(_ country: String, forLanguage language: String) {
            sendEvent("Search", action: "Country<\(country)|\(language)>")
        }
        
        static func citySearched(_ city: String, forLanguage language: String) {
            sendEvent("Search", action: "City<\(city)|\(language)>")
        }
        
        static func usersPaginatedInCity(_ city: String, forLanguage language: String, andPage page: String) {
            sendEvent("Scroll", action: "Pagination<City:\(city)|Language:\(language)|Page:\(page)")
        }
        
        static func usersPaginatedInCountry(_ country: String, forLanguage language: String, andPage page: String) {
            sendEvent("Scroll", action: "Pagination<Country:\(country)|Language:\(language)|Page:\(page)")
        }
        
        static func usersPaginatedInWorld(forLanguage language: String, andPage page: String) {
            sendEvent("Scroll", action: "Pagination<World|Language:\(language)|Page:\(page)")
        }
        
        static func userSearched(_ login: String) {
            sendEvent("Search", action: "User<\(login)>")
        }
        
        static func viewUserOnGithub(_ login: String) {
            sendEvent("Show", action: "UserGithub<\(login)>")
        }
        
        static func viewUserLanguagesOnGithub(_ login: String, language: String) {
            sendEvent("Show", action: "User<\(login)>Repositories<\(language)>")
        }
        
        static func searchedTrending(_ trendingScope: String, language: String) {
            sendEvent("Search", action: "Trending<\(trendingScope)>Language<\(language)>")
        }
        
        static func starRepoEvent(_ name: String) {
            sendEvent("Star", action: "Star Repo<\(name)>")
        }
        
        static func unstarRepoEvent(_ name: String) {
            sendEvent("Unstar", action: "Unstar Repo<\(name)>")
        }
        
        static func twoFactorAuthAlertShowedEvent() {
            sendEvent("Show", action: "2FA alert")
        }
        
        static func loggedInWithGitHub(_ withTwoFactorAuth: Bool) {
            let twoFactorAuth = withTwoFactorAuth ? "" : "out"
            sendEvent("Login", action: "GitHub Login with\(twoFactorAuth) 2FA")
        }
        
        static func loggedOutOfGitHub() {
            sendEvent("Logout", action: "GitHub Logout")
        }
        
        static func reviewInAppStoreEvent() {
            sendEvent("GoTo", action: "App Store")
        }
        
        static func viewOctoPodiumReadMeEvent() {
            sendEvent("Show", action: "OctoPodium Read Me")
        }
        
        static func starOctopodiumEvent() {
            sendEvent("Star", action: "OctoPodium Starred")
        }
        
        static func showDeveloperOnTwitterEvent(_ app: String) {
            sendEvent("GoTo", action: "Twitter Profile \(app)")
        }
        
        static func shareRankingOnTwitterEvent(_ app: String) {
            sendEvent("Share", action: "Twitter Profile \(app)")
        }
        
        static func showDeveloperOnGithubEvent() {
            sendEvent("GoTo", action: "GitHub Profile")
        }
        
        static func enabledAnimations() {
            sendEvent("Settings", action: "Enabled Animations")
        }
        
        static func disabledAnimations() {
            sendEvent("Settings", action: "Disabled Animations")
        }
    
        private static func callAsync(_ closure: @escaping () -> ()) {
            DispatchQueue.global().async {
                closure()
            }
        }
        
        private static func sendScreenView(_ screenName: String) {
//            callAsync {
//                executeIfRelease {
//                    tracker?.set(kGAIScreenName, value: screenName)
//                    let builder = GAIDictionaryBuilder.createScreenView()
//                    if let builder = builder {
//                        tracker?.send(builder.build() as [NSObject : AnyObject])
//                    }
//                }
//            }
        }
        
        private static func sendEvent(_ category: String, action: String, label: String? = nil) {
//            callAsync {
//                executeIfRelease {
//                    let l = label == nil ? action : label
//                    if let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: l, value: nil) {
//                        tracker?.send(builder.build() as [NSObject : AnyObject])
//                    }
//                }
//            }
        }
        
        private static func executeIfRelease(_ action: () -> () = {}) {
            if Analytics.shouldUse() {
                action()
            }
        }
    }
}
