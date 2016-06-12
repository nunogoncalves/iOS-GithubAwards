//
//  UIView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

extension UIView {
    func show() {
        hidden = false
    }
    
    func hide() {
        hidden = true
    }

    var width: CGFloat { get { return frame.width } }
    var height: CGFloat { get { return frame.height } }
   
    var halfWidth: CGFloat { get { return width / 2 } }
    var halfHeight: CGFloat { get { return height / 2 } }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(newValue) {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(CGColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(newValue) {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func removeAllSubviews() {
        for v in subviews  {
            v.removeFromSuperview()
        }
    }
    
    func applyGradient(colors: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        setNeedsLayout()
        layoutIfNeeded()
        gradient.frame = frame
        gradient.colors = colors.map { $0.CGColor }
        layer.addSublayer(gradient)
    }
    
    func animateInPath(path: UIBezierPath, withDuration duration: NSTimeInterval, onFinished: (() -> ())? = {}) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        anim.duration = duration
        
        anim.path = path.CGPath
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onFinished?()
        }
        layer.addAnimation(anim, forKey: "pathAnim")
    }
}
