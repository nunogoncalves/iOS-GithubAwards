//
//  GithubLoadingView.swift
//  GithubLoading
//
//  Created by Nuno Gonçalves on 29/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class GithubLoadingView: UIView, NibView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var loadingIndicatorImageView: UIImageView!
    @IBOutlet weak var staticImage: UIImageView!
    
    private let images = [
        UIImage(named: "GithubLoading-0.gif")!,
        UIImage(named: "GithubLoading-1.gif")!,
        UIImage(named: "GithubLoading-2.gif")!,
        UIImage(named: "GithubLoading-3.gif")!,
        UIImage(named: "GithubLoading-4.gif")!,
        UIImage(named: "GithubLoading-5.gif")!,
        UIImage(named: "GithubLoading-6.gif")!,
        UIImage(named: "GithubLoading-7.gif")!,
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        view.frame = frame
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
        view.frame = bounds
    }
    
    func afterCommonInit() {
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        staticImage.hidden = true
        
        setAnimation()
    }
    
    private func setAnimation() {
        loadingIndicatorImageView.image = images[0]
        loadingIndicatorImageView.animationImages = images
        loadingIndicatorImageView.animationDuration = 0.75
        loadingIndicatorImageView.startAnimating()
    }

    func setStaticWith(percentage: Int, offset: CGFloat) {
        
        staticImage.show()
        
        staticImage.hidden = abs(offset) < 30
        loadingIndicatorImageView.hidden = abs(offset) < 30
        
        var x = (100 / images.count) * percentage / 100
        if x > 7 { x = 7 }
        staticImage.image = images[x]
    }
    
    func stop() {
        staticImage.show()
    }
    
    func setLoading() {
        staticImage.hide()
    }
    
}
