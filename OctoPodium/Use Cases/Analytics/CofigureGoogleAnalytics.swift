//
//  CofigureGoogleAnalytics.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 28/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension Analytics {

    struct ConfigureGoogle {
        init() {
            if Analytics.shouldUse() {
                configure()
            }
        }
        
        private func configure() {
            let gai = GAI.sharedInstance()
            
            // Configure tracker from GoogleService-Info.plist.
            var configureError: NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            
            gai.trackUncaughtExceptions = true  // report uncaught exceptions
            gai.logger.logLevel = .None
        }
    }
}
