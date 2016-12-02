//
//  NotifyWarning.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class NotifyWarning: Notification {
    
    static func display(_ message: String? = nil) {
        Notification.instance.display(message, alertType: .warning)
    }
    
}
