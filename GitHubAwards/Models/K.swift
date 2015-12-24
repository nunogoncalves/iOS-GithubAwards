//
//  K.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 07/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class K {
    
    static let navAndTabBarsColor: UInt = 0x5C43AC
 
    static let firstInRankingColor: UInt = 0x5C43AC
    static let secondInRankingColor: UInt = 0x7C68BC
    static let thirdInRankingColor: UInt = 0x9D8ECD
    
    private static let apiBaseUrl = "http://d93ea47.ngrok.com"
//    static let apiBaseUrl = "http://localhost:2000"
    static let usersBaseUrl = "\(apiBaseUrl)/api/v0/users"
    static let languagesBaseUrl = "\(apiBaseUrl)/api/v0/languages"
}
