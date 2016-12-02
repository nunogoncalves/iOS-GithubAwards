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
        isHidden = false
    }
    
    func hide() {
        isHidden = true
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
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
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
    
    func applyGradient(_ colors: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        setNeedsLayout()
        layoutIfNeeded()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        layer.addSublayer(gradient)
    }
    
    func animateInPath(_ path: UIBezierPath, withDuration duration: TimeInterval, onFinished: (() -> ())? = {}) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        anim.duration = duration
        
        anim.path = path.cgPath
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onFinished?()
        }
        layer.add(anim, forKey: "pathAnim")
    }
}
