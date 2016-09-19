//
//  AlertView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

enum AlertType : UInt {
    case error = 0xFF0000
    case success = 0x00C10C
    case warning = 0xF2BF00
}

class AlertView: UIView, NibView {
    
    var type: String? = nil

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func afterCommonInit() {
        view.layoutIfNeeded()
        blurView.layoutIfNeeded()
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        visualEffectView.frame = CGRect(x: 0, y: 0, width: blurView.frame.width, height: blurView.frame.height)
        
        blurView.addSubview(visualEffectView)
    }
    
    func setStyle(_ style: AlertType) {
        view.backgroundColor = UIColor(hex: style.rawValue)
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
    
}
