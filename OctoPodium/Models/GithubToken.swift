//
//  GithubToken.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Locksmith

struct GithubToken {
    
    private let accountKey = "OctoPodiumGithubAccount"
    
    var token: String?
    
    private init() {
        token = get()
    }
    
    static var instance = GithubToken()
    
    func exists() -> Bool {
        return get() != nil
    }
    
    func get() -> String? {
        return getValueFor(accountKey)
    }
    
    mutating func saveOrUpdate(_ authToken: String) -> Bool {
        return saveOrUpdateValueFor(accountKey, value: authToken)
    }
    
   mutating private func save(_ authToken: String) -> Bool {
        return saveValueFor(accountKey, value: authToken)
    }
    
    private mutating func update(_ authToken: String) -> Bool {
        return updateValueFor(accountKey, value: authToken)
    }
    
    mutating func deleteSessionToken() -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: accountKey)
            token = nil
            return true
        } catch _ {
            return false
        }
    }

    private func getValueFor(_ key: String) -> String? {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: key)
        
        return dictionary?[key] as? String
    }
    
    private mutating func saveOrUpdateValueFor(_ key: String, value newValue: String) -> Bool {
        if let _ = get() {
            return updateValueFor(key, value: newValue)
        } else {
            return saveValueFor(key, value: newValue)
        }
    }
    
    private mutating func saveValueFor(_ key: String, value: String) -> Bool {
        do {
            try Locksmith.saveData(data: [key: value], forUserAccount: accountKey)
            token = value
            return true
        } catch _ {
            return false
        }
    }
    
    private mutating func updateValueFor(_ key: String, value: String) -> Bool {
        do {
            try Locksmith.updateData(data: [key: value], forUserAccount: accountKey)
            token = value
            return true
        } catch _ {
            return false
        }
    }
}

