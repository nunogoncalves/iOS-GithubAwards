//
//  BuildSessionConfiguration.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Network {
    
    class SessionConfigurationBuilder {
        
        static private var conf: URLSessionConfiguration?
        
        func sessionConfiguration() -> URLSessionConfiguration {
            var conf = SessionConfigurationBuilder.conf
            if SessionConfigurationBuilder.conf != nil {
                return SessionConfigurationBuilder.conf!
            }
            conf = URLSessionConfiguration.default()
            setupTimeouts(conf!)
            return conf!
        }
        
        private func setupTimeouts(_ configuration: URLSessionConfiguration) {
            configuration.timeoutIntervalForRequest = kTimeout.request
            configuration.timeoutIntervalForResource = kTimeout.resource
        }
        
    }
    
}
