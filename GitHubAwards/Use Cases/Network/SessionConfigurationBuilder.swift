//
//  BuildSessionConfiguration.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 10/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Network {
    
    class SessionConfigurationBuilder {
        
        static private var conf: NSURLSessionConfiguration?
        
        func sessionConfiguration() -> NSURLSessionConfiguration {
            var conf = SessionConfigurationBuilder.conf
            if SessionConfigurationBuilder.conf != nil {
                return SessionConfigurationBuilder.conf!
            }
            conf = NSURLSessionConfiguration.defaultSessionConfiguration()
            setupTimeouts(conf!)
            return conf!
        }
        
        private func setupTimeouts(configuration: NSURLSessionConfiguration) {
            configuration.timeoutIntervalForRequest = kTimeout.request
            configuration.timeoutIntervalForResource = kTimeout.resource
        }
        
    }
    
}