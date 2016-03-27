//
//  K.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct K {
    
    static let appName = "OctoPodium"
    static let appGithubRepository = "nunogoncalves/iOS-OctoPodium"
    static let appVersion = NSBundle.versionNumber()
    static let sourceCode = "https://github.com/nunogoncalves/iOS-OctoPodium"
    
    struct Colors {
        static let tabBarColor: UInt = 0x03436E
        static let navigationBarColor: UInt = 0x2F9DE6
        
        static let userGradientColors: [UInt] = [
            0x2F9DE6,
            0x3890C9,
            0x1468A1,
            0x03436E,
        ]
        
        static let userStartGradientColor: UInt = 0x338AC3
        static let userEndGradientColor: UInt = 0x2F9DE6
    
        static let firstInRankingColor: UInt = 0x5C43AC
        static let secondInRankingColor: UInt = 0x7C68BC
        static let thirdInRankingColor: UInt = 0x9D8ECD        
    }
    
    struct Urls {
        private static let apiBaseUrl = "http://github-awards.com"
        static let usersBaseUrl = "\(apiBaseUrl)/api/v0/users"
        static let languagesBaseUrl = "\(apiBaseUrl)/api/v0/languages"
        
        private static let githubApiBaseUrl = "https://api.github.com"
        static let githubLoginUrl = "\(githubApiBaseUrl)/authorizations"
        static let userUrl = "\(githubApiBaseUrl)/user"
    }
    
    struct Segues {
        static let showLanguageRankingSegue = "ShowLanguageRankingSegue"
        
        static let userDetailsSegue = "UserDetailsSegue"
        
        static let worldUsersSegue = "WorldUsersSegue"
        static let countryUsersSegue = "CountryUsersSegue"
        static let cityUsersSegue = "CityUsersSegue"
        
        static let userSearchToDetail = "UsersSearchToDetailSegue"
        static let trendingToUserDetailsSegue = "TrendingToUserDetailsSegue"
        static let showTrendingRepositoryDetailsSegue = "ShowTrendingRepositoryDetailsSegue"
        
        static let goToLoginSegue = "GoToLoginSegue"
        
        static let gotToTrendingDetailsFromSettingsSegue = "ShowOctoPodiumDetailsSegue"
    }
    
    struct Timeouts {
        static let request: NSTimeInterval = 5
        static let resource: NSTimeInterval = 5
    }
    
    struct Analytics {
        static let languagesScreen = "Languages Screen"
        
        static func rankingScreenFor(language: String?) -> String {
            return "Ranking Screen for \(language ?? "")"
        }
        
        static let userSearchScreen = "User Search Screen"
        static func userDetailsScreenFor(user: User?) -> String {
            if let login = user?.login {
                return "User Details Screen <\(login)>"
            } else {
                return "User Details Screen <Unkown>"
            }
        }
    }
    
    enum Fonts : String {
        case TitilliumWebBlack = "TitilliumWeb-Black"
        case TitilliumWebBold = "TitilliumWeb-Bold"
        case TitilliumWebBoldItalic = "TitilliumWeb-BoldItalic"
        case TitilliumWebExtraLight = "TitilliumWeb-ExtraLight"
        case TitilliumWebExtraLightItalic = "TitilliumWeb-ExtraLightItalic"
        case TitilliumWebItalic = "TitilliumWeb-Italic"
        case TitilliumWebLight = "TitilliumWeb-Light"
        case TitilliumWebLightItalic = "TitilliumWeb-LightItalic"
        case TitilliumWebRegular = "TitilliumWeb-Regular"
        case TitilliumWebSemibold = "TitilliumWeb-SemiBold"
        case TitilliumWebSemiBoldItalic = "TitilliumWeb-SemiBoldItalic"
        
        var all : [Fonts] {
            return [
                TitilliumWebBlack,
                TitilliumWebBold,
                TitilliumWebBoldItalic,
                TitilliumWebExtraLight,
                TitilliumWebExtraLightItalic,
                TitilliumWebItalic,
                TitilliumWebLight,
                TitilliumWebLightItalic,
                TitilliumWebRegular,
                TitilliumWebSemibold,
                TitilliumWebSemiBoldItalic,
            ]
        }
        
        var allValues : [String] {
            return all.map { $0.rawValue }
        }
        
        func fontWith(size: CGFloat) -> UIFont {
            return UIFont(name: rawValue, size: size)!
        }
    }
    
}

typealias kColors = K.Colors
typealias kUrls = K.Urls
typealias kSegues = K.Segues
typealias kTimeout = K.Timeouts
typealias kAnalytics = K.Analytics
typealias kFonts = K.Fonts