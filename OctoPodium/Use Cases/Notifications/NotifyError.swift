//
//  AlertError.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Foundation

class NotifyError: NSObject {
    
    static let errorDuration: NSTimeInterval = 0.75
    static let window = UIApplication.sharedApplication().keyWindow!

    static var isDisplaying = false
    
    static func display(message: String? = nil) {
        if isDisplaying {
            return
        }
        isDisplaying = true
        
        let v = AlertView(frame: CGRectMake(0, -64, window.frame.width, 80))
        if let message = message {
            v.setMessage(message)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "onTap:")
        v.addGestureRecognizer(tapGesture)
        
        window.addSubview(v)
        
        UIView.animateWithDuration(
            0.75,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                v.frame = CGRectMake(0, 0, window.frame.width, 80)
            }, completion: { _ in
                self.performSelector("dismiss:", withObject: v, afterDelay: 1.25)
            }
        )
    }
    
    @objc private static func onTap(tapGesture: UITapGestureRecognizer) {
        dismiss(tapGesture.view!)
    }
    
    static func dismiss(view: UIView) {
        UIView.animateWithDuration(0.3, animations: {
            view.frame = CGRectOffset(view.frame, 0, -128)
            }, completion: { _ in
                view.removeFromSuperview()
                isDisplaying = false
            }
        )
    }

}