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
    
    func isSelf() -> Bool {
        guard let login = login else { return false }
        guard let user = User.getUserInUserDefaults() else { return false }
        return login == user.login
    }
    
    private static let loggedInUserLoginKey = "OctoPodiumLoggedUserLogin"
    private static let loggedInUserAvatarUrlKey = "OctoPodiumLoggedUserAvatarUrl"
    
    func saveInUserDefaults() {
        User.saveUserInUserDefaults(self)
    }
    
    class func saveUserInUserDefaults(user: User) {
        NSUserDefaults().setObject(user.login, forKey: User.loggedInUserLoginKey)
        NSUserDefaults().setObject(user.avatarUrl, forKey: User.loggedInUserAvatarUrlKey)
    }

    class func getUserInUserDefaults() -> User? {
        let defs = NSUserDefaults()
        
        if let login = defs.objectForKey(User.loggedInUserLoginKey) as? String {
            let avatarUrl = defs.objectForKey(User.loggedInUserAvatarUrlKey) as? String
            let user = User(login: login, avatarUrl: avatarUrl ?? "")
            return user
        }
        
        return nil
    }
    
    class func removeUserFromDefaults() {
        NSUserDefaults().removeObjectForKey(loggedInUserLoginKey)
        NSUserDefaults().removeObjectForKey(loggedInUserAvatarUrlKey)
    }
    
}
