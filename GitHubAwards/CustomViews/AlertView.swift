//
//  AlertView.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var blurView: UIView!
    
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
        visualEffectView.frame = CGRectMake(0, 0, blurView.frame.width, blurView.frame.height)
        
        blurView.addSubview(visualEffectView)
    }
    
    private func loadViewFromNib() {
        NSBundle.mainBundle().loadNibNamed("AlertView", owner: self, options: nil)
        addSubview(view)
    }
    
}
