//
//  GithubLoadingView.swift
//  GithubLoading
//
//  Created by Nuno Gonçalves on 29/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class GithubLoadingView: UIView {

    private let animatedImageView = UIImageView.usingAutoLayout()
    private let staticImageView = UIImageView.usingAutoLayout()
    
    private let images = (0...7).map { UIImage(named: "GithubLoading-\($0).gif")! }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()

        staticImageView.isHidden = true
        setAnimation()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()

        staticImageView.isHidden = true
        setAnimation()
    }

    private func commonInit() {
        [animatedImageView, staticImageView].forEach {
            addSubview($0)

            UIView.set($0.widthAnchor, 30)
            UIView.set($0.heightAnchor, 30)

            $0.centerX(==, self)
            $0.centerY(==, self)
        }
    }

    private func setAnimation() {
        animatedImageView.image = images[0]
        animatedImageView.animationImages = images
        animatedImageView.animationDuration = 0.75
        animatedImageView.startAnimating()
    }

    func fix(at percentage: Int, offset: CGFloat) {
        
        staticImageView.show()
        
        staticImageView.isHidden = abs(offset) < 30
        animatedImageView.isHidden = abs(offset) < 30
        
        var x = (100 / images.count) * percentage / 100
        if x > 7 { x = 7 }
        staticImageView.image = images[x]
    }
    
    func stop() {
        staticImageView.show()
        animatedImageView.stopAnimating()
    }

    func setLoading() {
        staticImageView.hide()
        animatedImageView.startAnimating()
    }
    
}
