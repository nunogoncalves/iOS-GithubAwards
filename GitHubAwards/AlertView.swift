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
        view = loadViewFromNib()
        view.layoutIfNeeded()
        blurView.layoutIfNeeded()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        visualEffectView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        
        blurView.addSubview(visualEffectView)
        
        print(view.frame)
        print(blurView.frame)
        print(visualEffectView.frame)
        
        view.layoutIfNeeded()
        blurView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AlertView", bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
}
