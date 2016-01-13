//
//  K.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 07/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct K {
    
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
    }
    
    struct Segues {
        static let userDetailsSegue = "UserDetailsSegue"
        
        static let worldUsersSegue = "WorldUsersSegue"
        static let countryUsersSegue = "CountryUsersSegue"
        static let cityUsersSegue = "CityUsersSegue"
        
        static let userSearchToDetail = "UsersSearchToDetailSegue"
    }
    
    struct Timeouts {
        static let request: NSTimeInterval = 5
        static let resource: NSTimeInterval = 5
    }
}

typealias kColors = K.Colors
typealias kUrls = K.Urls
typealias kSegues = K.Segues
typealias kTimeout = K.Timeouts