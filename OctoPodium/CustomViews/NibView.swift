//
//  NibView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 14/05/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol NibView {
    
    var view: UIView! { get }
    
    func commonInit()
    func afterCommonInit()

}

extension NibView where Self : UIView {
    
    func commonInit() {
        loadViewFromNib()
        view.frame = bounds
        view.layoutIfNeeded()
        afterCommonInit()
    }
    
    
    private func loadViewFromNib() {
        NSBundle.mainBundle().loadNibNamed(String(Self), owner: self, options: nil)
        addSubview(view)
    }
    
}
