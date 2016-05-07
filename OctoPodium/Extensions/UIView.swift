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
}
