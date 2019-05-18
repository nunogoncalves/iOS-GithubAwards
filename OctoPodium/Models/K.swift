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
    static let appId = "1077519133"
    static let appVersion = Bundle.versionNumber()
    
    static let appOwnerName = "nunogoncalves"
    static let appRepositoryName = "iOS-OctoPodium"
    static let appOwnerGithub = URL(string: "https://github.com/\(appOwnerName)")!
    static let appGithubRepository = "\(appOwnerGithub)/\(appRepositoryName)"
    
    
    static let twitterHandle = "goncalvescmnuno"
    
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
        private static let apiBaseUrl = "http://git-awards.com"
        static let usersBaseUrl = "\(apiBaseUrl)/api/v0/users"
        static let languagesBaseUrl = "\(apiBaseUrl)/api/v0/languages"
        
        private static let githubApiBaseUrl = "https://api.github.com"
        static let githubLoginUrl = "\(githubApiBaseUrl)/authorizations"
        static let userUrl = "\(githubApiBaseUrl)/user"

        static var doStarRepoUrl = { (repoOwner: String, repoName: String) in
            "\(githubApiBaseUrl)/user/starred/\(repoOwner)/\(repoName)"
        }
        
        static var doUnstarRepoUrl = { (repoOwner: String, repoName: String) in
            doStarRepoUrl(repoOwner, repoName)
        }
        
        static var githubStarredRepoUrl = { (repoOwner: String, repoName: String) in
            "\(githubApiBaseUrl)/user/starred/\(repoOwner)/\(repoName)"
        }
    }
    
    struct Segues {
        static let userSearchToDetail = "UsersSearchToDetailSegue"
        static let trendingToUserDetailsSegue = "TrendingToUserDetailsSegue"
        static let showTrendingRepositoryDetailsSegue = "ShowTrendingRepositoryDetailsSegue"
        
        static let goToLoginSegue = "GoToLoginSegue"
    }
    
    struct Timeouts {
        static let request: TimeInterval = 5
        static let resource: TimeInterval = 5
    }
    
    struct Analytics {
        static let languagesScreen = "Languages Screen"
        
        static func rankingScreen(for language: String?) -> String {
            return "Ranking Screen for \(language ?? "")"
        }
        
        static let userSearchScreen = "User Search Screen"
        static func userDetailsScreenFor(_ user: User?) -> String {
            if let login = user?.login {
                return "User Details Screen <\(login)>"
            } else {
                return "User Details Screen <Unkown>"
            }
        }
    }
}

typealias kColors = K.Colors
typealias kUrls = K.Urls
typealias kSegues = K.Segues
typealias kTimeout = K.Timeouts
typealias kAnalytics = K.Analytics
