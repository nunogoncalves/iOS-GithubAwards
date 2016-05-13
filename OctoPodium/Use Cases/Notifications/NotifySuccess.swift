//
//  NotifySuccess.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class NotifySuccess: Notification {
    
    static func display(message: String? = nil) {
        Notification.instance.display(message, alertType: .Success)
    }
    
}