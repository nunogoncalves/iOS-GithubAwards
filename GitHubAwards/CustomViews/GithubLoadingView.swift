//
//  GithubLoadingView.swift
//  GithubLoading
//
//  Created by Nuno Gonçalves on 29/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class GithubLoadingView: UIView {

    var view: UIView!
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
        commontInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commontInit()
    }
    
    func commontInit() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        loadingIndicatorImageView.image = UIImage(named: "GithubLoading-0.gif")!
        loadingIndicatorImageView.animationImages = images
        loadingIndicatorImageView.animationDuration = 0.75
        loadingIndicatorImageView.startAnimating()

        staticImage.hidden = true
        addSubview(view)
    }

    func setStaticWith(percentage: Int, offset: CGFloat) {
        
        staticImage.hidden = false
        
        staticImage.hidden = abs(offset) < 30
        loadingIndicatorImageView.hidden = abs(offset) < 30
        
        var x = (100 / images.count) * percentage / 100
        if x > 7 { x = 7 }
        staticImage.image = images[x]
    }
    
    func setLoading() {
        staticImage.hidden = true
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "GithubLoadingView", bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
