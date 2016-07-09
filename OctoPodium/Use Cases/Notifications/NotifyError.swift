//
//  AlertError.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

class NotifyError: Notification {
    
    static func display(_ message: String? = nil) {
        Notification.instance.display(message, alertType: .error)
    }
    
}
