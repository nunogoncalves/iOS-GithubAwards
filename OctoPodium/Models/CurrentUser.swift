//
//  CurrentUser.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class CurrentUser : User {
    
    private static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    private static let animationsEnabledKey = "Octopodium-AnimationsEnabled"
    
    static func setUpInitialConfigurations() {
        if userDefaults.objectForKey(animationsEnabledKey) == nil {
            enableAnimations()
        }
    }
    
    static var hasAnimationsEnabled: Bool {
        return userDefaults.boolForKey(animationsEnabledKey) ?? true
    }
    
    static func enableAnimations() {
        setAnimationsState(true)
    }
    
    static func disableAnimations() {
        setAnimationsState(false)
    }
    
    private static func setAnimationsState(state: Bool) {
        userDefaults.setBool(state, forKey: animationsEnabledKey)
    }
    
}
