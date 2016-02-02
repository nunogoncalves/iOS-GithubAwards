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
    var height: CGFloat { get { return frame.width } }
   
    var halfWidth: CGFloat { get { return width / 2 } }
    var halfHeight: CGFloat { get { return height / 2 } }
}
