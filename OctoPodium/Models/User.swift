//
//  User.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class User {
    var login: String
    var avatarUrl: String
    
    var city: String?
    var country: String?
    
    var starsCount: Int?
    
    var rankings: [Ranking] = []
    
    init(login: String, avatarUrl: String) {
        self.login = login
        self.avatarUrl = avatarUrl
    }
    
    var hasLocation: Bool {
        return  hasCountry || hasCity
    }
    
    var hasCountry: Bool {
        return country != nil && country != ""
    }
    
    var hasCity: Bool {
        return city != nil && city != ""
    }
    
    var isSelf: Bool {
        guard let user = User.getUserInUserDefaults() else { return false }
        return login == user.login
    }
    
    private static let loggedInUserLoginKey = "OctoPodiumLoggedUserLogin"
    private static let loggedInUserAvatarUrlKey = "OctoPodiumLoggedUserAvatarUrl"
    
    func saveInUserDefaults() {
        User.saveUserInUserDefaults(self)
    }
    
    class func saveUserInUserDefaults(_ user: User) {
        UserDefaults().set(user.login, forKey: User.loggedInUserLoginKey)
        UserDefaults().set(user.avatarUrl, forKey: User.loggedInUserAvatarUrlKey)
    }

    class func getUserInUserDefaults() -> User? {
        let defs = UserDefaults()
        
        if let login = defs.object(forKey: User.loggedInUserLoginKey) as? String {
            let avatarUrl = defs.object(forKey: User.loggedInUserAvatarUrlKey) as? String
            let user = User(login: login, avatarUrl: avatarUrl ?? "")
            return user
        }
        
        return nil
    }
    
    class func removeUserFromDefaults() {
        UserDefaults().removeObject(forKey: loggedInUserLoginKey)
        UserDefaults().removeObject(forKey: loggedInUserAvatarUrlKey)
    }
    
}

extension User {

    //TODO use codable
    convenience init(from json: [String: Any]) {

        self.init(login: (json["login"] as? String) ?? "",
                  avatarUrl: (json["gravatar_url"] as? String) ?? "")

        self.starsCount = (json["stars_count"] as? Int) ?? 0
    }
}
