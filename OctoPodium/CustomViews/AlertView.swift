//
//  AlertView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commontInit()
    }
    
    func commontInit() {
        loadViewFromNib()
        
        view.layoutIfNeeded()
        blurView.layoutIfNeeded()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        visualEffectView.frame = CGRect(x: 0, y: 0, width: blurView.frame.width, height: blurView.frame.height)
        
        blurView.addSubview(visualEffectView)
    }
    
    private func loadViewFromNib() {
        NSBundle.mainBundle().loadNibNamed(String(AlertView), owner: self, options: nil)
        addSubview(view)
    }
    
    func setMessage(message: String) {
        messageLabel.text = message
    }
    
}
