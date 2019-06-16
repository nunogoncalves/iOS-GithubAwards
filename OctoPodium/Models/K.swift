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
        static let showTrendingRepositoryDetailsSegue = "ShowTrendingRepositoryDetailsSegue"
        
        static let goToLoginSegue = "GoToLoginSegue"
    }

    struct Analytics {
        static let languagesScreen = "Languages Screen"
        
        static func rankingScreen(for language: String?) -> String {
            return "Ranking Screen for \(language ?? "")"
        }
        
        static let userSearchScreen = "User Search Screen"
        static func userDetailsScreen(for user: User?) -> String {
            if let login = user?.login {
                return "User Details Screen <\(login)>"
            } else {
                return "User Details Screen <Unkown>"
            }
        }
    }
}

typealias kUrls = K.Urls
typealias kSegues = K.Segues
typealias kAnalytics = K.Analytics

extension UIColor {
    static let tabBarColor = UIColor(hex: 0x03436E)
    static let navigationBarColor = UIColor(hex: 0x2F9DE6)

    static let userGradientColors: [UIColor] = [
        UIColor(hex: 0x2F9DE6),
        UIColor(hex: 0x3890C9),
        UIColor(hex: 0x1468A1),
        UIColor(hex: 0x03436E),
    ]

    static let userStartGradientColor = UIColor(hex: 0x338AC3)
    static let systemBlue = UIColor(hex: 0x2F9DE6)
    static let userEndGradientColor = systemBlue

    static let firstInRankingColor = UIColor(hex: 0x5C43AC)
    static let secondInRankingColor = UIColor(hex: 0x7C68BC)
    static let thirdInRankingColor = UIColor(hex: 0x9D8ECD)
}

extension TimeInterval {
    static let timeout: TimeInterval = 5
    static let resource: TimeInterval = 5
}

extension CGSize {
    static let loadingViewSize: CGSize = CGSize(floatLiteral: 90)
}

struct Layout {
    private init() {}
    enum Size {
        static let searchBarHeight: CGFloat = 44
        static let loadingView: CGFloat = CGSize.loadingViewSize.height
    }
}
