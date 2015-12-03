//
//  AlertError.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Foundation

class AlertError: NSObject {
    
    static let errorDuration: NSTimeInterval = 0.75
    
    static func alertError() {
        
        let window = UIApplication.sharedApplication().keyWindow!
        let v = AlertView(frame: CGRectMake(0, -64, window.frame.width, 128)).view
        window.addSubview(v)
        
        UIView.animateWithDuration(
            0.75,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.3,
            options: [],
            animations: {
                v.frame = CGRectMake(0, 64, window.frame.width, 64)
            }, completion: nil
        )
        
        performSelector("dismiss:", withObject: v, afterDelay: 2.0)
    }
    
    static func dismiss(view: UIView) {
        UIView.animateWithDuration(0.3, animations: {
            view.frame = CGRectOffset(view.frame, 0, -64)
            }, completion: { _ in
                view.removeFromSuperview()
            }
        )
    }

}