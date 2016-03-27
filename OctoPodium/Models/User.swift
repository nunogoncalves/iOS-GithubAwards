//
//  User.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class User {
    var login: String?
    var avatarUrl: String?
    
    var city: String?
    var country: String?
    
    var starsCount: Int?
    
    var rankings: [Ranking] = []
    
    init(login: String, avatarUrl: String) {
        self.login = login
        self.avatarUrl = avatarUrl
    }
    
    func hasLocation() -> Bool {
        return  hasCountry() || hasCity()
    }
    
    func hasCountry() -> Bool {
        return country != nil && country != ""
    }
    
    func hasCity() -> Bool {
        return city != nil && city != ""
    }
    
    private static let octoPodiumLoggedInUserKey = "OctoPodiumLoggedUser"
    
    func saveInUserDefaults() {
        User.saveUserInUserDefaults(login!)
    }
    
    class func saveUserInUserDefaults(login: String) {
        NSUserDefaults().setObject(login, forKey: User.octoPodiumLoggedInUserKey)
    }

    class func getUserInUserDefaults() -> String? {
        return NSUserDefaults().objectForKey(User.octoPodiumLoggedInUserKey) as? String
    }
    
    class func removeUserFromDefaults() {
        NSUserDefaults().removeObjectForKey(octoPodiumLoggedInUserKey)
    }
    
}
