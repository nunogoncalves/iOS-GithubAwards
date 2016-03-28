//
//  SendToGoogle.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension Analytics {
    
    struct SendToGoogle {
        
        private static let tracker = GAI.sharedInstance().defaultTracker
        private static let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        
        static func enteredScreen(screenName: String) {
            sendScreenView(screenName)
        }
        
        static func countrySearched(country: String, forLanguage language: String) {
            sendEvent("Search", action: "Country<\(country)|\(language)>")
        }
        
        static func citySearched(city: String, forLanguage language: String) {
            sendEvent("Search", action: "City<\(city)|\(language)>")
        }
        
        static func usersPaginatedInCity(city: String, forLanguage language: String, andPage page: String) {
            sendEvent("Scroll", action: "Pagination<City:\(city)|Language:\(language)|Page:\(page)")
        }
        
        static func usersPaginatedInCountry(country: String, forLanguage language: String, andPage page: String) {
            sendEvent("Scroll", action: "Pagination<Country:\(country)|Language:\(language)|Page:\(page)")
        }
        
        static func usersPaginatedInWorld(forLanguage language: String, andPage page: String) {
            sendEvent("Scroll", action: "Pagination<World|Language:\(language)|Page:\(page)")
        }
        
        static func userSearched(login: String) {
            sendEvent("Search", action: "User<\(login)>")
        }
        
        static func viewUserOnGithub(login: String) {
            sendEvent("Show", action: "UserGithub<\(login)>")
        }
        
        static func viewUserLanguagesOnGithub(login: String, language: String) {
            sendEvent("Show", action: "User<\(login)>Repositories<\(language)>")
        }
        
        static func searchedTrending(trendingScope: String, language: String) {
            sendEvent("Search", action: "Trending<\(trendingScope)>Language<\(language)>")
        }
        
        static func twoFactorAuthAlertShowedEvent() {
            sendEvent("Show", action: "2FA alert")
        }
        
        static func loggedInWithGitHub(withTwoFactorAuth: Bool) {
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
        
        static func showDeveloperOnTwitterEvent() {
            sendEvent("GoTo", action: "Twitter Profile")
        }
        
        static func showDeveloperOnGithubEvent() {
            sendEvent("GoTo", action: "GitHub Profile")
        }

        
        private static func callAsync(closure: () -> ()) {
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                closure()
            }
        }
        
        private static func sendScreenView(screenName: String) {
            callAsync {
                executeIfRelease {
                    tracker.set(kGAIScreenName, value: screenName)
                    let builder = GAIDictionaryBuilder.createScreenView()
                    tracker.send(builder.build() as [NSObject : AnyObject])
                }
            }
        }
        
        private static func sendEvent(category: String, action: String, label: String? = nil) {
            callAsync {
                executeIfRelease {
                    let l = label == nil ? action : label
                    let builder = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: l, value: nil)
                    tracker.send(builder.build() as [NSObject : AnyObject])
                }
            }
        }
        
        private static func executeIfRelease(action: () -> () = {}) {
            if Analytics.shouldUse() {
                action()
            }
        }
    }
}
