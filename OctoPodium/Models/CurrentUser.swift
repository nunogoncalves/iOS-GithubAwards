//
//  CurrentUser.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class CurrentUser : User {
    
    private static let userDefaults = UserDefaults.standard
    
    private static let animationsEnabledKey = "Octopodium-AnimationsEnabled"
    
    static func setUpInitialConfigurations() {
        if userDefaults.object(forKey: animationsEnabledKey) == nil {
            enableAnimations()
        }
    }
    
    static var hasAnimationsEnabled: Bool {
        return userDefaults.bool(forKey: animationsEnabledKey) 
    }
    
    static func enableAnimations() {
        setAnimationsState(true)
    }
    
    static func disableAnimations() {
        setAnimationsState(false)
    }
    
    private static func setAnimationsState(_ state: Bool) {
        userDefaults.set(state, forKey: animationsEnabledKey)
    }
    
    private func isLoggedIn() -> Bool {
        return GithubToken.instance.exists()
    }
}
