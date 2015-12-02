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
        let v = UIView(frame: CGRectMake(0, -100, window.frame.width, 100))
        v.alpha = 0.5
        v.backgroundColor = UIColor.redColor()
        
        let bounds = v.frame
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        window.addSubview(v)
        window.addSubview(visualEffectView)
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [], animations: {
            v.frame = CGRectOffset(v.frame, 0, 64)
            }, completion: nil)
        
        performSelector("dismiss:", withObject: [v, visualEffectView], afterDelay: 2.0)
    }
    
    static func dismiss(views: [UIView]) {
        let v = views[0]
        UIView.animateWithDuration(0.3, animations: {
            v.frame = CGRectOffset(v.frame, 0, -64)
            }, completion: { _ in
                v.removeFromSuperview()
                views[1].removeFromSuperview()
            }
        )
    }

}